//
//  LiningViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/15.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

enum TiningStyle:Int {
    case Tining_white
    case Tining_misewenlu
    case Tining_fangguxuanzhi
    case Tining_huisezhigan
    case Tining_heiseyaguang
}
enum TiningSize:Int {
    case Tining_0
    case Tining_2P5
    case Tining_5
    case Tining_7P5
    case Tining_10
}

class LiningViewController: BaseViewController {
    var picModel:PictureModel!
    @IBOutlet weak var tiningWidthImageView: UIImageView!
    @IBOutlet weak var bottomScrollView: UIScrollView!
    @IBOutlet weak var bottonChooseView: UIView!
    var tiningStyle:TiningStyle = .Tining_white
    var tiningSize:TiningSize = .Tining_2P5
    var tiningStyleArray:[String] = ["neichen_baise","neichen_mise","neichen_fanggu","neichen_huise","neichen_heise"]
    var tiningSizeArray:[String] = ["0","2.5","5","7.5","10"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func buildUI() {
        self.title = MRLanguage(forKey: "Lining")
        self.baseNavigationController?.addRightNavigationBarItems(["neichen_yingyonghuakuang"], ["neichen_yingyonghuakuang"], nil, rightCallBack: { [weak self](tag) in
            self?.requestData()
        })
    }
    
    override func requestData() {
        network.requestData(.paint_lining, params: ["frame_colour":tiningStyle.rawValue,"frame_size":tiningSize.rawValue], finishedCallback: { [weak self](result) in
            if result["ret"] as! Int == 0 {
                HUDTool.show(.text, text: MRLanguage(forKey: "Linng") + "设置成功", delay: 0.8, view: (self?.view)!, complete: nil)
            }
        }, nil)
    }
    
    @IBAction func chooseTiningStyleAction(_ sender: UIButton) {
        tiningStyle = TiningStyle(rawValue: sender.tag - 10)!
        let name = tiningStyleArray[tiningStyle.rawValue] + tiningSizeArray[tiningSize.rawValue] + "cm"
        tiningWidthImageView.image = UIImage.init(named: name)
    }
    
    @IBAction func chooseTiningSizeAction(_ sender: UIButton) {
        tiningSize = TiningSize(rawValue: sender.tag - 20)!
        let name = tiningStyleArray[tiningStyle.rawValue] + tiningSizeArray[tiningSize.rawValue] + "cm"
        tiningWidthImageView.image = UIImage.init(named: name)
    }
    
    @IBAction func tiningStyleOrSizeAction(_ sender: UIButton) {
        for i in 0 ..< 2 {
            let btn = self.view.viewWithTag(30+i) as! UIButton
            if btn == sender {
                UIView.animate(withDuration: 0.25, animations: {
                    self.bottonChooseView.x = btn.x
                    if i == 0 {
                        self.bottomScrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
                    }else if i == 1 {
                        self.bottomScrollView.setContentOffset(CGPoint.init(x: self.bottomScrollView.width, y: 0), animated: true)
                    }
                }, completion: { (finished) in
                    
                })
            }else {
                btn.isSelected = false
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
