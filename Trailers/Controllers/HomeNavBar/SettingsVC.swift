//
//  SettingsVC.swift
//  Netflix Clone
//
//  Created by ithink on 09/09/22.
//

import UIKit
import MessageUI

class SettingsVC: UIViewController {
    
    private let sectionTitles  = [ ["Theme", "Sound", "Vibration", "Language"],
                                   ["Rate us", "Recommend Trailers", "Terms of Services", "Privacy & Policy"],
                                   ["Contact us", "About"],
                                   [""] ]
    private let sectionImageNames = [ ["paintbrush", "speaker.wave.2", "wave.3.right", "textformat.alt"],
                                      ["star", "arrowshape.turn.up.forward", "doc.text", "lock.shield"],
                                      ["person.wave.2", "info.circle"],
                                      [""] ]
    
    private let settingsTableView = UITableView(frame: .zero, style: .insetGrouped)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray4
        configureNavBar()
        configureTableView()
    }
    
    // MARK: - Functions
    
    private func configureNavBar() {
        let label = UILabel()
        label.text = "Settings"
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .label
        navigationItem.titleView = label
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = Color.buttonColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped(_:)))
    }
    
    private func configureTableView() {
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.register(SettingsTVC.self, forCellReuseIdentifier: SettingsTVC.identifier)
        view.addSubview(settingsTableView)
    }
    
    private func sendEmail() {
        
        func configuredMailComposeViewController() -> MFMailComposeViewController {
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self

            mailComposerVC.setToRecipients(["jonibekbekmuratov99@gmail.com"])
            mailComposerVC.setSubject("Trailers App FeedBack")
            mailComposerVC.setMessageBody("Hello Trailers Team,\n", isHTML: false)

            return mailComposerVC
        }
     
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    private func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        sendMailErrorAlert.addAction(action)
        present(sendMailErrorAlert, animated: true)
    }
    
    
    // MARK: - @objc Functions
    
    @objc private func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    // MARK: - Layout & Constraints
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        settingsTableView.frame = view.bounds
    }

}

// MARK: - SettingsTableView Delegate & DataSource

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTVC.identifier, for: indexPath) as? SettingsTVC else {return UITableViewCell()}
        let title = sectionTitles[indexPath.section][indexPath.row]
        let imageName = sectionImageNames[indexPath.section][indexPath.row]
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 1,2:
                cell.configureCellWith(title: title, image: imageName, hasSwitch: true)
                cell.selectionStyle = .none
            case 3:
                cell.configureCellWith(title: "\(title) (Coming Soon)", image: imageName, hasSwitch: false)
                cell.accessoryType = .disclosureIndicator
                cell.isUserInteractionEnabled = false
                cell.backgroundColor = .separator
            default:
                cell.configureCellWith(title: title, image: imageName, hasSwitch: false)
                cell.accessoryType = .disclosureIndicator
            }
        case 1:
            cell.configureCellWith(title: "\(title) (Coming Soon)", image: imageName, hasSwitch: false)
            cell.backgroundColor = .separator
            cell.accessoryType = .disclosureIndicator
            cell.isUserInteractionEnabled = false
        case 3:
            cell.configureCellWith(title: title, image: imageName, hasSwitch: false)
            cell.accessoryType = .none
            cell.textLabel?.text = "Trailers Version 1.0"
            cell.textLabel?.textAlignment = .center
            cell.isUserInteractionEnabled = false
            cell.textLabel?.font = .preferredFont(forTextStyle: .headline)
        default:
            cell.configureCellWith(title: title, image: imageName, hasSwitch: false)
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionTitles[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let popoverVC = ThemePopoverVC()
                self.navigationController?.pushViewController(popoverVC, animated: true)
            default:
                break;
            }
        case 2:
            switch indexPath.row {
            case 0:
                sendEmail()
            case 1:
                let aboutVC = AboutVC()
                self.navigationController?.pushViewController(aboutVC, animated: true)
            default:
                break;
            }
        default:
            break;
        }
    }
}


// MARK: MFMailComposeViewControllerDelegate
extension SettingsVC: MFMailComposeViewControllerDelegate {
    
    private func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismiss(animated: true, completion: nil)
    }
}
