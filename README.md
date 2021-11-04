# Demo_PanGesture

- 팬 제스처 테스트 용 데모 프로젝트
- 팬 제스처를 통하여 뷰의 사이즈 조절 및 메인 뷰와 서브 뷰의 동장 분할에 용이
- 중앙 사각 뷰를 클릭 시 테스트 시작

## Library

- SPM 사용
- [SnapKit ~> 5.0.0 next Major] 레이아웃 수정을 위한 라이브러리 

## ProjectMain

- 프로젝트 메인 관련 그룹

## ProjectUtil

- 프로젝트 설정 및 파일 관련 그룹

## ViewController

- 팬 제스처 뷰 
- [mainTopView] 메인 뷰 (일정 제스처 동작 시 고정 높이 표시)
- [mainBottomView] 서브 뷰 (메인에 관련된 정보를 표시하는 서브 뷰)
- [mainTopCenterView] 메인 내부의 중앙에 위치한 뷰 (뷰 알파값 조절 확인 용)
- [mainTopChildView] 메인 내부의 아래에 위치한 뷰 (뷰 고정 확인 용, 뷰 알파값 조절 확인 용)
