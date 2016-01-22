INPUTDATE=`date`
git pull
git add .
git reset -- gitcommit.sh
git commit -m "Commit Date $INPUTDATE"
git remote add origin git@github.com:Saulabrm/Python-Optimization.git
git push -u origin master
