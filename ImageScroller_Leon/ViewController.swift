//
//  ViewController.swift
//  ImageScroller_Leon
//
//  Created by lai leon on 2017/9/3.
//  Copyright © 2017 clem. All rights reserved.
//

import UIKit

let YHRect = UIScreen.main.bounds
let YHHeight = YHRect.size.height
let YHWidth = YHRect.size.width

class ViewController: UIViewController {
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: YHRect)
        /*自动布局
         flexibleLeftMargin  自动调整view与父视图左边距，保证右边距不变
         flexibleWidth       自动调整view的宽度，保证左边距和右边距不变
         flexibleRightMargin 自动调整view与父视图右边距，以保证左边距不变
         flexibleTopMargin   自动调整view与父视图上边距，以保证下边距不变
         flexibleHeight      自动调整view的高度，以保证上边距和下边距不变
         flexibleBottomMargin自动调整view与父视图的下边距，以保证上边距不变
         */
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.backgroundColor = .clear
        return scrollView
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Steve"))
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //背景
        setupBG()
        //scrollView
        setupScrollView()
        //设置缩放
        setZoomScaleFor(scrollViewSize: scrollView.bounds.size)
        scrollView.zoomScale = scrollView.minimumZoomScale
        //重新定位image
        recenterImage()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func setupBG() {
        view.layer.contents = UIImage(named: "Steve")?.cgImage
        let visual = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visual.frame = YHRect
        view.addSubview(visual)
    }

    private func setupScrollView() {
        scrollView.contentSize = imageView.bounds.size
        scrollView.delegate = self
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
    }

    private func setZoomScaleFor(scrollViewSize: CGSize) {
        let imageSize = imageView.bounds.size
        let widthScale = scrollViewSize.width / imageSize.width
        let heightScale = scrollViewSize.height / imageSize.height
        let minScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 3.5
    }

    func recenterImage() {
        let scrollViewSize = scrollView.bounds.size
        let imageViewSize = imageView.frame.size
        let horizontalSpace = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2.0 : 0
        let verticalSpace = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.width) / 2.0 : 0
        scrollView.contentInset = UIEdgeInsetsMake(verticalSpace, horizontalSpace, verticalSpace, horizontalSpace)
    }

    //重写方法
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setZoomScaleFor(scrollViewSize: scrollView.bounds.size)
        if scrollView.zoomScale < scrollView.minimumZoomScale {
            scrollView.zoomScale = scrollView.minimumZoomScale
        }
        recenterImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ViewController: UIScrollViewDelegate {
    //缩放后调用
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        recenterImage()
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        //要缩放时调用，返回需要缩放的view
        return imageView
    }
}