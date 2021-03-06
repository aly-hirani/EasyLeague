//
//  LeagueHomeViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/22/22.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class LeagueHomeViewController: UIViewController {
    
    static let reuseIdentifier = "LeagueHomeButtonsCell"
    
    static let buttons: [(name: String, imageName: String, color: UIColor, enabled: (League) -> Bool, controller: (League, Team) -> UIViewController)] = [
        ("Matchups", "calendar", .systemRed, { _ in true }, { league, team in
            let controller = MatchupsViewController()
            controller.league = league
            controller.team = team
            return controller
        }),
        ("Standings", "list.number", .systemOrange, { _ in true }, { league, _ in
            let controller = StandingsViewController()
            controller.league = league
            return controller
        }),
        ("Team Statistics", "person.2.fill", .systemYellow, { league in !league.teamStats.isEmpty }, { league, _ in
            let controller = TeamStatisticsViewController()
            controller.league = league
            return controller
        }),
        ("Player Statistics", "figure.walk", .systemGreen, { league in !league.playerStats.isEmpty }, { league, _ in
            let controller = PlayerStatisticsViewController()
            controller.league = league
            return controller
        }),
        ("League Info", "info", .systemBlue, { _ in true }, { league, _ in
            let controller = LeagueInfoViewController()
            controller.league = league
            return controller
        }),
    ]
    
    var user: User!
    
    var league: League!
    
    var team: Team!
    
    lazy var editButton = createBarButton(item: .edit, action: #selector(editButtonPressed))
    
    lazy var buttonsCollection = createCollection(for: self, reuseIdentifier: Self.reuseIdentifier, cellType: UICollectionViewListCell.self)
    
    var leagueListener: ListenerRegistration?
    
    deinit {
        leagueListener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .appBackground
        
        navigationItem.title = league.name
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = editButton
        
        view.addSubview(buttonsCollection)
        
        constrainToSafeArea(buttonsCollection)
        
        addListener()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureLayout()
    }
    
    func configureLayout() {
        if let layout = buttonsCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: buttonsCollection.bounds.width - 20, height: 75)
            layout.minimumLineSpacing = 20
            layout.sectionInset = UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 7)
        }
    }
    
    func addListener() {
        leagueListener = Firestore.firestore().leagueCollection.document(league.id).addSnapshotListener { documentSnapshot, _ in
            guard let snapshot = documentSnapshot else { return }
            guard let league = try? snapshot.data(as: League.self) else { return }
            self.league = league
            self.navigationItem.title = self.league.name
        }
    }

}

@objc extension LeagueHomeViewController {
    
    func editButtonPressed() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Share Invite Identifier", style: .default) { _ in
            let activity = UIActivityViewController(activityItems: [self.league.id], applicationActivities: nil)
            self.present(activity, animated: true)
        })
        alert.addAction(UIAlertAction(title: "Enter Scores", style: .default) { _ in
            guard self.user.id == self.league.ownerUserID else {
                return self.presentSimpleAlert(title: "Enter Scores Error", message: "Only the league owner can enter scores")
            }
            guard self.league.results.count < self.league.schedule.count else {
                return self.presentSimpleAlert(title: "Enter Scores Error", message: "League is over!")
            }
            let controller = EnterScoresViewController()
            controller.league = self.league
            self.show(controller, sender: self)
        })
        alert.addAction(UIAlertAction(title: "Edit League", style: .default) { _ in
            let editController = EditLeagueViewController()
            editController.user = self.user
            editController.league = self.league
            editController.team = self.team
            self.show(editController, sender: self)
        })
        alert.addAction(UIAlertAction(title: "Delete League", style: .destructive) { _ in
            let alert = UIAlertController(title: "Would you like to delete this league? This operation is permanent.", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
                let spinner = self.addSpinner()
                Firestore.firestore().leagueCollection.document(self.league.id).delete { error in
                    spinner.remove()
                    if let error = error {
                        self.presentSimpleAlert(title: "Delete League Error", message: error.localizedDescription)
                    } else {
                        self.popFromNavigation()
                    }
                }
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
}

extension LeagueHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Self.buttons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.reuseIdentifier, for: indexPath)
        guard let cell = cell as? UICollectionViewListCell else { return cell }
        cell.accessories = [.disclosureIndicator()]
        
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowOffset = CGSize(width: 1, height: 2)
        cell.layer.shadowRadius = 3
        
        var background = UIBackgroundConfiguration.listPlainCell()
        background.backgroundColor = .systemGray6
        background.cornerRadius = 15
        cell.backgroundConfiguration = background
        
        var content = cell.defaultContentConfiguration()
        let data = Self.buttons[indexPath.row]
        content.text = data.name
        content.textProperties.font = .systemFont(ofSize: 17, weight: .semibold)
        content.image = UIImage(systemName: data.imageName)
        content.imageProperties.tintColor = data.color
        cell.isUserInteractionEnabled = data.enabled(league)
        cell.contentConfiguration = content
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        show(Self.buttons[indexPath.row].controller(league, team), sender: self)
    }
    
}
