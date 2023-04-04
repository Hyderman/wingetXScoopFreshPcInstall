winget install powershell --force
pwsh -Command {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    irm get.scoop.sh | iex
    scoop install aria2
    scoop install python
    python childScript.py 
}