echo "Enter your commit message"
read message

git add .
git commit -m "${message}"

if [ -n "$(git status --porcelain)" ];
then
    echo "No changes found"
else
    git status
    echo "Pushing data to remote server!!!"
    git push origin binit
    flutter build apk --split-per-abi
fi