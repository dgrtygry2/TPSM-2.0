@echo off
cls
REM Set the file paths for training data and user information
set "data_file=data.txt"
set "log_file=log.txt"
set "brain_file=brain.txt"
set "chatbotname_file=chatbotname.txt"
set "username_file=username.txt"

REM Initialize the chatbot name
if exist "%chatbotname_file%" (
    for /f "usebackq delims=" %%a in ("%chatbotname_file%") do set "chatbot_name=%%a"
) else (
    set "chatbot_name=TrainBot"
)

REM Initialize the username
if exist "%username_file%" (
    for /f "usebackq delims=" %%a in ("%username_file%") do set "username=%%a"
) else (
    set "username=User"
)

REM Welcome message
echo Hello, %username%! I am %chatbot_name%, your trainbot. I can generate sentences based on what I've learned.

REM Main training loop
:train_loop
set /p user_input="You: "
if "%user_input%"=="" goto :train_loop
if /i "%user_input%"=="exit" goto :train_end

echo You: %user_input% >> %data_file%
echo %user_input% >> %log_file%

echo %chatbot_name%: How should I respond?
set /p bot_response="You (provide response): "

echo %chatbot_name%: Learning from your response...
echo %bot_response% >> %log_file%

REM Generate questions, prompts, and interest inquiries based on the context of the conversation
set "questions="
set "prompts="
set "interest_inquiries="

for /f "delims=" %%a in (%log_file%) do (
    set "response=%%a"
    call :generate_context "%%a"
)

echo %chatbot_name%: Possible questions based on the context: %questions%
echo %chatbot_name%: %questions% >> %brain_file%
echo %chatbot_name%: Prompts based on the context: %prompts%
echo %chatbot_name%: %prompts% >> %brain_file%
echo %chatbot_name%: Interest inquiries: %interest_inquiries%
echo %chatbot_name%: %interest_inquiries% >> %brain_file%

echo %chatbot_name%: %bot_response%
echo %chatbot_name%: %bot_response% >> %log_file%

goto :train_loop

:generate_context
setlocal
set "response=%~1"

if /i "%response%"=="I like it." set "questions=%questions% Why do you like it?" & set "prompts=%prompts% What else do you like?"
if /i "%response%"=="I don't understand." set "questions=%questions% What don't you understand?" & set "prompts=%prompts% Can you explain further?"
if /i "%response%"=="I agree." set "questions=%questions% Why do you agree?" & set "prompts=%prompts% What do you agree with?"

REM General curiosity questions
set "questions=%questions% Out of curiosity, why do you think this?"
set "prompts=%prompts% Out of curiosity, what do you mean by this?"
set "questions=%questions% Just curious, why do you think this?"
set "prompts=%prompts% Just curious, what do you mean by this?"

endlocal & set "questions=%questions%" & set "prompts=%prompts%"
exit /b

:train_end
REM Return to the main menu or exit
set /p return_to_menu="Return to the main menu? (Y/N): "
if /i "%return_to_menu%"=="Y" (
    if exist TSPM.bat (
        call TSPM.bat
    ) else (
        echo Main menu script not found. Exiting...
        exit
    )
) else (
    exit
)
