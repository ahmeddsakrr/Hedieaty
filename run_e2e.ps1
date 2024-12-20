# Set variables
$ON_DEVICE_OUTPUT_FILE = "/sdcard/test_video.mp4"
$OUTPUT_VIDEO = "e2e_test_video.mp4"
$DRIVER_PATH = "test_driver/integration_test_driver.dart"
$TEST_PATH = "integration_test/end_to_end_test.dart"
$DeviceId = "emulator-5554"
$HTML_OUTPUT = "e2e_test_results.html"
$DeviceSize = "1080x1920"
$OUTPUT_LOG_PATH = "e2e_test_output.log"

# Helper function to write to log and console
function Log-Message {
    param ([string]$message)
    Write-Output $message
    $message | Out-File -FilePath $OUTPUT_LOG_PATH -Append
}

if (Test-Path $OUTPUT_VIDEO) { Remove-Item $OUTPUT_VIDEO }

# Ensure no existing screenrecord process is running
Log-Message "Checking for existing screenrecord processes..."
$existingRecording = & adb -s $DeviceId shell "ps | grep screenrecord"
if ($existingRecording) {
    Log-Message "Killing existing screenrecord process..."
    & adb -s $DeviceId shell "killall screenrecord"
    Start-Sleep -Seconds 2
}

# Clear any existing recording file
Log-Message "Clearing any existing recording file..."
& adb -s $DeviceId shell "rm -f $ON_DEVICE_OUTPUT_FILE"

# Start recording on the device with proper format
Log-Message "Starting screen recording..."
$adbCommand = "adb -s $DeviceId shell `"screenrecord --bit-rate 6000000 --size $DeviceSize --time-limit 180 $ON_DEVICE_OUTPUT_FILE`""
$recordingProcess = Start-Process -FilePath "powershell" -ArgumentList "-Command", $adbCommand -PassThru -WindowStyle Hidden

Start-Sleep -Seconds 5

if (-not $recordingProcess) {
    Log-Message "Failed to start screen recording. Exiting."
    exit 1
}

# Run the Flutter drive test and capture the output
Log-Message "Running Flutter drive test..."
try {
    $testOutput = & flutter drive --device-id=$DeviceId --driver=$DRIVER_PATH --target=$TEST_PATH
} catch {
    Log-Message "Flutter drive test failed. Error: $_"
    $recordingProcess | Stop-Process -Force
    exit 1
}

# Give the recording time to finalize
Log-Message "Finalizing recording..."
Start-Sleep -Seconds 5

# Properly stop the recording
Log-Message "Stopping screen recording..."
& adb -s $DeviceId shell "killall screenrecord"
Start-Sleep -Seconds 2

# Verify the video file exists on device
$fileExists = & adb -s $DeviceId shell "ls $ON_DEVICE_OUTPUT_FILE 2>/dev/null"
if (-not $fileExists) {
    Log-Message "Video file not found on device. Recording may have failed."
    exit 1
}

# Get file size to verify it's not empty
$fileSize = & adb -s $DeviceId shell "stat -f %z $ON_DEVICE_OUTPUT_FILE"
if ([int]$fileSize -lt 1024) {
    Log-Message "Video file appears to be empty or too small."
    exit 1
}

# Pull the video file from the device
Log-Message "Pulling video from device..."
try {
    & adb -s $DeviceId pull $ON_DEVICE_OUTPUT_FILE $OUTPUT_VIDEO
    if ($LASTEXITCODE -eq 0) {
        Log-Message "Video pulled successfully."

        # Verify local file exists and has content
        if ((Test-Path $OUTPUT_VIDEO) -and ((Get-Item $OUTPUT_VIDEO).length -gt 1024)) {
            Log-Message "Video file verified successfully."
        } else {
            throw "Local video file is missing or empty"
        }
    } else {
        throw "adb pull command failed with exit code $LASTEXITCODE"
    }
} catch {
    Log-Message "Failed to pull video file. Error: $_"
    exit 1
}

# Determine test status
$status = if ($testOutput -match "All tests passed.") { "Pass" } else { "Fail" }
Log-Message "Test status: $status"

# Save test output to log file
Log-Message "Saving test output to log file..."
$testOutput | Out-File -FilePath $OUTPUT_LOG_PATH

# Pull the video file from the device
Log-Message "Pulling video from device..."
try {
    & adb -s $DeviceId pull $ON_DEVICE_OUTPUT_FILE $OUTPUT_VIDEO
    if ($LASTEXITCODE -eq 0) {
        Log-Message "Video pulled successfully."
    } else {
        throw "adb pull command failed with exit code $LASTEXITCODE"
    }
} catch {
    Log-Message "Failed to pull video file. Error: $_"
    exit 1
}


# Generate HTML report
Log-Message "Generating HTML report..."
$htmlContent = @"
<!DOCTYPE html>
<html>
<head>
    <title>Test Results</title>
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
        }
        th, td {
            border: 1px solid black;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        .status-pass {
            color: white;
            background-color: green;
            padding: 5px;
            border-radius: 4px;
        }
        .status-fail {
            color: white;
            background-color: red;
            padding: 5px;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <h1>Test Results</h1>
    <p><strong>Device ID:</strong> $DeviceId</p>
    <p><strong>Test Run Timestamp:</strong> $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")</p>
    <table>
        <thead>
            <tr>
                <th>Testcase #</th>
                <th>Testcase Name</th>
                <th>Status</th>
                <th>Video</th>
                <th>Logs</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>1</td>
                <td>End To End</td>
                <td><span class="status-$(if ($status -eq "Pass") { "pass" } else { "fail" })">$status</span></td>
                <td><a href="$OUTPUT_VIDEO">Download Video</a></td>
                <td><a href="$OUTPUT_LOG_PATH">Logs</a></td>
            </tr>
        </tbody>
    </table>
</body>
</html>
"@

# Save HTML content to a file
try {
    Set-Content -Path $HTML_OUTPUT -Value $htmlContent
    Log-Message "HTML report saved to $HTML_OUTPUT."
} catch {
    Log-Message "Failed to save HTML report. Error: $_"
    exit 1
}

Log-Message "Test script execution completed successfully."
