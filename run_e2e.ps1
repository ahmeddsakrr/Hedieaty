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

Log-Message "Starting screen recording..."
$adbCommand = "adb -s $DeviceId shell `"screenrecord --size $DeviceSize --time-limit 180 $ON_DEVICE_OUTPUT_FILE`""
$recordingProcess = Start-Process -FilePath "powershell" -ArgumentList "-Command", $adbCommand -PassThru -NoNewWindow

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
    # Kill the recording process before exiting
    $recordingProcess | Stop-Process -Force
    exit 1
}

# Give the recording a moment to finish
Start-Sleep -Seconds 2

# Kill the recording process to ensure it stops properly
$recordingProcess | Stop-Process -Force

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
