# Break popup: topmost dark window, button unlocks after 10 s.
param([int]$Index = 0, [string]$Sound = "")

Add-Type -AssemblyName System.Windows.Forms, System.Drawing

$lines = @(
  "Even the Dark Passenger sleeps. Stand up and stretch.",
  "Harry would want you to drink some water.",
  "Leave the lab. Get some sun on your face.",
  "Look away from the screen. Count the slides. Slowly.",
  "Time to wear the mask. Go talk to a human.",
  "Clean the tools. Rest the eyes. Blink."
)
$line = $lines[$Index % $lines.Count]

# Muted palette.
$rose = [System.Drawing.Color]::FromArgb(201, 130, 130)
$soft = [System.Drawing.Color]::FromArgb(208, 208, 214)
$dim = [System.Drawing.Color]::FromArgb(130, 132, 140)
$form = New-Object System.Windows.Forms.Form
$form.Text = "Kill room cleared"
$form.Size = New-Object System.Drawing.Size(560, 340)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.ControlBox = $false
$form.TopMost = $true
$form.BackColor = [System.Drawing.Color]::FromArgb(30, 31, 36)

$drop = New-Object System.Windows.Forms.Label
$drop.Text = [char]0x25CF
$drop.Font = New-Object System.Drawing.Font("Segoe UI", 40)
$drop.ForeColor = $rose
$drop.AutoSize = $false
$drop.TextAlign = "MiddleCenter"
$drop.SetBounds(0, 10, 560, 80)
$form.Controls.Add($drop)

$title = New-Object System.Windows.Forms.Label
$title.Text = "BREAK TIME"
$title.Font = New-Object System.Drawing.Font("Consolas", 22, [System.Drawing.FontStyle]::Bold)
$title.ForeColor = $rose
$title.AutoSize = $false
$title.TextAlign = "MiddleCenter"
$title.SetBounds(0, 90, 560, 45)
$form.Controls.Add($title)

$text = New-Object System.Windows.Forms.Label
$text.Text = $line
$text.Font = New-Object System.Drawing.Font("Segoe UI", 13)
$text.ForeColor = $soft
$text.AutoSize = $false
$text.TextAlign = "MiddleCenter"
$text.SetBounds(20, 140, 520, 70)
$form.Controls.Add($text)

$btn = New-Object System.Windows.Forms.Button
$btn.Font = New-Object System.Drawing.Font("Consolas", 12)
$btn.ForeColor = $dim
$btn.BackColor = [System.Drawing.Color]::FromArgb(44, 46, 53)
$btn.FlatStyle = "Flat"
$btn.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(70, 72, 80)
$btn.SetBounds(180, 230, 200, 44)
$script:ready = $false
$btn.Add_Click({ if ($script:ready) { $form.Close() } })
$form.Controls.Add($btn)

$left = 10
$btn.Text = "Wait $left s"
$tick = New-Object System.Windows.Forms.Timer
$tick.Interval = 1000
$tick.Add_Tick({
  $script:left--
  if ($script:left -le 0) {
    $tick.Stop(); $script:ready = $true; $btn.ForeColor = $soft; $btn.FlatAppearance.BorderColor = $rose; $btn.Text = "Back to work"; $btn.Focus()
  } else { $btn.Text = "Wait $($script:left) s" }
})
$form.Add_Shown({
  $form.Activate(); $tick.Start()
  if ($Sound -and (Test-Path $Sound)) { (New-Object Media.SoundPlayer $Sound).Play() }
})
[void]$form.ShowDialog()
