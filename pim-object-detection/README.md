# pim-object-detection
Class project files for Robot Vision by Professor Jong-woo Lim at SNU ME.

### Project Description
We add a PIM module to various object detection models and test their efficacy on diverse datasets. 

### Members
이승섭, 김건우, 최진석 (SNU ME)


### GIT LFS 시스템 사용 방법
Git lfs를 이용해 대용량 파일을 깃허브로 공유하는 방식입니다.
출처1: https://docs.github.com/en/repositories/working-with-files/managing-large-files/installing-git-large-file-storage
출처2: https://docs.github.com/en/repositories/working-with-files/managing-large-files/configuring-git-large-file-storage

I. git lfs 설치하기
1. git-lfs.com 에 들어가서 다운로드
2. 사용하는 터미널에서 `git lfs install` 치고 `Git LFS Initialized` 확인하기. 이 때 vscode 내장 터미널에서도 한번 써줘야 제대로 작동합니다.

II. git lfs로 파일 공유하기
3. 터미널 안에서 git lfs가 필요한 폴더로 이동 후 `git lfs track "파일명.확장자" `로 git lfs로 옮길 파일 설정 (저는 `git lfs track "*.tgz"`로 .tgz 파일들을 트래킹함)
4. 이 때 생성된 .gitattributes 파일 유지하기.
5. 이후 정상적으로 git add, git commit, git push/pull 등 실행하기.