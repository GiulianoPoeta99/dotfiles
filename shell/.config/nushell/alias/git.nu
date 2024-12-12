def glz [] {
   lazygit
}
def gi [] {
   git init
}
def gcl [] {
   git clone --progress
}
def gclv [] {
   git clone -v --progress
}
def gs [] {
   git status
}
def gss [] {
   git status -s
}
def gl [] {
   git log --all --oneline --graph
}
def gla [] {
   git log --all --graph
}
def glt [] {
   git log --pretty=%h»¦«%aN»¦«%s»¦«%aD | lines | split column "»¦«" sha1 committer desc merged_at | first 15
}
def glup [] {
   git log --pretty=%h»¦«%aN»¦«%s»¦«%aD | lines | split column "»¦«" sha1 committer desc merged_at | histogram committer merger | sort-by merger | reverse
}
def ga [] {
   git add -v
}
def gaa [] {
   git add -Av
}
def gc [] {
   git commit
}
def gcm [] {
   git commit -m
}
def gcam [] {
   git commit -am
}
def gca [] {
   git commit --amend
}
def gpl [] {
   git pull
}
def gps [] {
   git push
}
def gpst [] {
   git push --follow-tags origin main
}
def gco [] {
   git checkout
}
def gcom [] {
   git checkout main
}
def gcob [] {
   git checkout -b
}
def gb [] {
   git branch
}
def gr [] {
   git remote
}
def grv [] {
   git remote -v
}
def gra [] {
   git remote add
}
def gm [] {
   git merge
}
def grh [] {
   git reset HEAD~
}
def gf [] {
   git fetch
}
def gfu [] {
   git fetch upstream
}
def gsh [] {
   git stash
}
def gshl [] {
   git stash list
}
def gshs [] {
   git stash show -p
}
def gsha [] {
   git stash apply
}
def gshd [] {
   git stash drop
}
def gsmi [] {
   git submodule init
}
def gsmdi [] {
   git submodule deinit
}
def gsmu [] {
   git submodule update
}
def gsma [] {
   git submodule add
}
def gsms [] {
   git submodule init and git submodule update
}
def gsmrn [] {
   git mv
}