//
//  ViewController.swift
//  DraggingViewTest
//
//  Created by yuhyeonjae on 2021/08/04.
//

import UIKit
import SnapKit

// MARK: - 뷰 상태
extension ViewController {
    enum ViewState {
        /// 닫힘
        case CLOSE
        /// 부분 표시
        case PARTIAL
        /// 전체 표시
        case FULL
    }
}

class ViewController: UIViewController {
    // MARK: - 상수
    let FIX_HEIGHT: CGFloat = 300
    let CENTER_VIEW_SIZE: CGFloat = 50
    let CHILD_VIEW_SIZE: CGFloat = 30
    
    // MARK: - 뷰
    /// 메인 탑 뷰
    private var mainTopView: UIView? = nil
    /// 메인 바텀 뷰 (제스처를 통한 움직임 뷰)
    private var mainBottomView: UIView? = nil
    /// 메인 탑 뷰 중앙  뷰
    private var mainTopCenterView: UIView? = nil
    /// 메인 탑 뷰 자식 뷰
    private var mainTopChildView: UIView? = nil
    
    // MARK: - 활용 변수
    var mainTopViewHeight: CGFloat = 0
    var mainBottomViewHeight: CGFloat = 0
    /// 현재 뷰 상태
    var stateValue: ViewState = .CLOSE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    /// 뷰 셋팅
    private func initView() {
        if nil == self.mainTopView {
            self.mainTopView = UIView()
            self.mainTopView?.backgroundColor = .red
            self.view.addSubview(self.mainTopView ?? UIView())
        }
        
        if nil == self.mainBottomView {
            self.mainBottomView = UIView()
            self.mainBottomView?.backgroundColor = .blue
            self.view.addSubview(self.mainBottomView ?? UIView())
        }
        
        if nil == self.mainTopCenterView {
            self.mainTopCenterView = UIView()
            self.mainTopCenterView?.backgroundColor = .green
            self.mainTopView?.addSubview(self.mainTopCenterView ?? UIView())
        }
        
        if nil == self.mainTopChildView {
            self.mainTopChildView = UIView()
            self.mainTopChildView?.backgroundColor = .yellow
            self.mainTopView?.addSubview(self.mainTopChildView ?? UIView())
        }
        
        // 레이아웃 업데이트
        self.updateLayout()
    }
    
    /// 레이아웃 업데이트
    private func updateLayout() {
        self.mainTopView?.snp.removeConstraints()
        self.mainTopView?.snp.makeConstraints({ make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(self.FIX_HEIGHT)
        })
        
        self.mainBottomView?.snp.removeConstraints()
        self.mainBottomView?.snp.makeConstraints({ make in
            make.top.equalTo(self.mainTopView!.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        })
                    
        self.mainTopCenterView?.snp.removeConstraints()
        self.mainTopCenterView?.snp.makeConstraints({ make in
            make.width.height.equalTo(self.CENTER_VIEW_SIZE)
            make.centerX.centerY.equalToSuperview()
        })
        
        self.mainTopChildView?.snp.removeConstraints()
        self.mainTopChildView?.snp.makeConstraints { make in
            make.width.height.equalTo(self.CHILD_VIEW_SIZE)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        // 뷰 초기 설정
        self.initSettingView()
    }
    
    /// 뷰 초기 설정
    private func initSettingView() {
        // 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesutureProcess))
        self.mainTopView?.isUserInteractionEnabled = true
        self.mainTopView?.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(self.panGesture))
        self.mainBottomView?.addGestureRecognizer(panGesture)
        
        // 초기 닫기 화면
        self.moveView(.CLOSE)
    }
    
    /// 업데이트 뷰
    private func updateView() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.allowUserInteraction], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

// MARK: - ㄴ 팬 제스처 관련
extension ViewController {
    /// 팬 제스처 동작
    @objc private func panGesture(_ recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began || recognizer.state == .changed {
            // 제스처 실행 시
            if recognizer.state == .began {
                // 뷰 사이즈 저장
                self.mainTopViewHeight = self.mainTopView?.frame.height ?? 0
                self.mainBottomViewHeight = self.mainBottomView?.frame.height ?? 0
                
                self.mainTopView?.snp.remakeConstraints({ remake in
                    remake.top.leading.trailing.equalToSuperview()
                    remake.bottom.equalTo(self.mainBottomView!.snp.top)
                })
                
                self.mainBottomView?.snp.remakeConstraints({ remake in
                    remake.height.equalTo(self.mainBottomViewHeight)
                    remake.leading.trailing.bottom.equalToSuperview()
                })
            }
            // 움직임 처리
            self.moveView(panGestureRecognizer: recognizer)
        } else if recognizer.state == .ended {
            // 제스처 종료 시
            let moveY = recognizer.translation(in: view).y
            
            if moveY > self.view.frame.height / 4 {
                self.moveView(.CLOSE)
            } else if moveY <= 0 {
                self.moveView(.FULL)
            } else if self.stateValue == .PARTIAL, moveY >= 0 {
                self.moveView(.CLOSE)
            } else {
                self.moveView(.PARTIAL)
            }
            
            self.updateView()
        }
    }
    
    /// 상태 타입 입력으로 진행
    private func moveView(_ state: ViewState) {
        // 1. 상태 저장
        self.stateValue = state
        
        // 2. 상태에 맞춰 레이아웃 변경
        switch state {
        case .CLOSE:
            self.setAlphaProcess(1.0, 0.0)
            
            self.mainTopView?.snp.remakeConstraints({ remake in
                remake.top.leading.trailing.bottom.equalToSuperview()
            })
            
            self.mainBottomView?.snp.remakeConstraints({ remake in
                remake.top.equalTo(self.mainTopView!.snp.bottom)
                remake.leading.trailing.bottom.equalToSuperview()
            })
        case .PARTIAL:
            self.setAlphaProcess(0.0, 1.0)
            
            self.mainTopView?.snp.remakeConstraints({ remake in
                remake.top.leading.trailing.equalToSuperview()
                remake.height.equalTo(self.FIX_HEIGHT)
            })
            
            self.mainBottomView?.snp.remakeConstraints({ remake in
                remake.top.equalTo(self.mainTopView!.snp.bottom)
                remake.leading.trailing.bottom.equalToSuperview()
            })
        default:
            self.setAlphaProcess(0.0, 1.0)
            
            self.mainTopView?.snp.remakeConstraints({ remake in
                remake.top.leading.trailing.equalToSuperview()
                remake.height.equalTo(0)
            })
            
            self.mainBottomView?.snp.remakeConstraints({ remake in
                remake.top.equalTo(self.mainTopView!.snp.bottom)
                remake.leading.trailing.bottom.equalToSuperview()
            })
        }
    }
    
    /// 제스처 입력으로 진행
    private func moveView(panGestureRecognizer recognizer: UIPanGestureRecognizer) {
        /*
         스와이프 속도 (양수 음수로 위 아래 방향을 파악 가능)
         - recognizer.velocity(in: self.view)
         스와이프 드래그 움직임 (현재 위치를 0을 기점으로 하여 -+ 진행)
         - recognizer.translation(in: self.view)
         현재 터치한 위치
         - recognizer.location(in: self.view)
         */
        
        let translation = recognizer.translation(in: view)
        let velocity = recognizer.velocity(in: view)
        
        switch self.stateValue {
        case .FULL:
            // 고정 크기 아래로 내려갈 경우
            if self.mainBottomView!.frame.minY >= self.FIX_HEIGHT {
                self.changeAlphaProcess(velocity.y)
                
                self.mainTopView?.snp.remakeConstraints({ remake in
                    remake.top.leading.trailing.equalToSuperview()
                    remake.bottom.equalTo(self.mainBottomView!.snp.top)
                })
            } else {
                self.setAlphaProcess(0.0, 1.0)
                
                self.mainTopView?.snp.remakeConstraints({ remake in
                    remake.top.leading.trailing.equalToSuperview()
                    remake.height.equalTo(self.FIX_HEIGHT)
                })
            }
            
            self.mainBottomView?.snp.updateConstraints({ update in
                update.height.equalTo(self.mainBottomViewHeight - translation.y)
            })
        case .PARTIAL:
            // 고정 크기 위로 올라갈 경우
            if self.mainBottomView!.frame.minY <= self.FIX_HEIGHT {
                self.setAlphaProcess(0.0, 1.0)
                
                self.mainTopView?.snp.remakeConstraints({ remake in
                    remake.top.leading.trailing.equalToSuperview()
                    remake.height.equalTo(self.FIX_HEIGHT)
                })
            } else {
                self.changeAlphaProcess(velocity.y)
                
                self.mainTopView?.snp.remakeConstraints({ remake in
                    remake.top.leading.trailing.equalToSuperview()
                    remake.bottom.equalTo(self.mainBottomView!.snp.top)
                })
            }
            
            self.mainBottomView?.snp.updateConstraints({ update in
                update.height.equalTo(self.mainBottomViewHeight - translation.y)
            })
        default:
            break
        }
    }
    
    /// 뷰 알파 설정
    private func setAlphaProcess(_ centerViewAlphaValue: CGFloat, _ childViewAlphaValue: CGFloat) {
        self.mainTopCenterView?.alpha = centerViewAlphaValue
        self.mainTopChildView?.alpha = childViewAlphaValue
    }
    
    /// 뷰 알파 변경
    private func changeAlphaProcess(_ velocityYPosition: CGFloat) {
        if velocityYPosition > 0 {
            if self.mainTopCenterView?.alpha != 1.0 {
                self.mainTopCenterView?.alpha += 0.02
                self.mainTopChildView?.alpha -= 0.02
            }
        } else {
            if self.mainTopCenterView?.alpha != 0.0 {
                self.mainTopCenterView?.alpha -= 0.02
                self.mainTopChildView?.alpha += 0.02
            }
        }
    }
}

// MARK: - ㄴ 터치 제스처
extension ViewController {
    /// 뷰 터치시 동작
    @objc private func tapGesutureProcess(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            if self.stateValue == .CLOSE {
                self.moveView(.PARTIAL)
                self.updateView()
            }
        }
    }
}
