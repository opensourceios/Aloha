//
//  GIFPreviewViewController.swift
//  AlohaGIF
//
//  Created by Michal Pyrka on 26/04/2017.
//  Copyright © 2017 Michal Pyrka. All rights reserved.
//

import UIKit
import FLAnimatedImage
import FBSDKMessengerShareKit

class GIFPreviewViewController: UIViewController {

    var gifURL: URL?
    @IBOutlet private weak var modalContainerView: UIView!
    @IBOutlet private weak var gifImageView: FLAnimatedImageView!
    @IBOutlet private weak var gifImageViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraintsIfNeeded()
        guard let gifData = gifData() else { return }
        gifImageView.animatedImage = FLAnimatedImage(animatedGIFData: gifData)
        ALLoadingView.manager.coverContent()
        Logger.info("User is looking at GIF preview.")
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        ALLoadingView.manager.hideLoadingView()
        dismiss(animated: true) {
            self.completeGifProcess()
        }
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
        if let gif = gifData() {
            Logger.info("User tapped on default iOS share.")
            let activityViewController = UIActivityViewController(activityItems: [gif], applicationActivities: nil)
            present(activityViewController, animated: true)
        }
    }
    
    @IBAction func messengerButtonAction(_ sender: UIButton) {
        if let gif = gifData() {
            Logger.info("User tapped on Messenger share.")
            FBSDKMessengerSharer.shareAnimatedGIF(gif, with: FBSDKMessengerShareOptions())
        }
    }
    
    private func setupConstraintsIfNeeded() {
        let isSmallerThan47InchDisplay = UIScreen.main.nativeBounds.height < 1334.0
        guard isSmallerThan47InchDisplay else { return }
        let newGifImageViewHeightConstraint = NSLayoutConstraint(item: gifImageViewHeightConstraint.firstItem, attribute: gifImageViewHeightConstraint.firstAttribute, relatedBy: gifImageViewHeightConstraint.relation, toItem: gifImageViewHeightConstraint.secondItem, attribute: gifImageViewHeightConstraint.secondAttribute, multiplier: 0.55, constant: 0.0)
        gifImageViewHeightConstraint.isActive = false
        gifImageViewHeightConstraint = newGifImageViewHeightConstraint
        gifImageViewHeightConstraint.isActive = true
        modalContainerView.layoutIfNeeded()
    }
    
    private func completeGifProcess() {
        NotificationCenter.default.post(name: .unmuteNotification, object: nil)
        clearTemporaryFilesFolder()
    }
    
    private func clearTemporaryFilesFolder() {
        do {
            let temp = NSTemporaryDirectory()
            let filePaths = try FileManager.default.contentsOfDirectory(atPath: temp)
            try filePaths.forEach { try FileManager.default.removeItem(atPath: temp + $0) }
        } catch {
            Logger.error("Could not clear temporary files folder. Reason: \(error.localizedDescription)")
        }
    }
    
    private func gifData() -> Data? {
        if let gifURL = gifURL {
            return try? Data(contentsOf: gifURL)
        } else {
            return nil
        }
    }
}
