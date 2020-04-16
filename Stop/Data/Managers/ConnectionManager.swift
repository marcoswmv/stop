//
//  ConnectionManager.swift
//  Stop
//
//  Created by Marcos Vicente on 13.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ConnectionManager: NSObject {
    
    static let shared = ConnectionManager()
    
    let serviceType = "mwmv-stop"
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcNearbyServiceBrowser: MCNearbyServiceBrowser!
    var mcNearbyServiceAdvertiser: MCNearbyServiceAdvertiser!
    
    var dataToReceive: Game?
    var notification = ""
    
    deinit {
        print("Stopping and deallocating everything...")
    }
    
    func setupSession() {
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
    }
    
    func setupNearbyServiceBrowser(browse: Bool, viewController: UIViewController) {
        if browse {
            mcNearbyServiceBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
            mcNearbyServiceBrowser.delegate = viewController as? MCNearbyServiceBrowserDelegate
            mcNearbyServiceBrowser.startBrowsingForPeers()
        } else {
            mcNearbyServiceBrowser.stopBrowsingForPeers()
        }
    }
    
    func startSelfAdvertising(advertise: Bool, viewController: UIViewController) {
        if advertise {
            mcNearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
            mcNearbyServiceAdvertiser.delegate = viewController as? MCNearbyServiceAdvertiserDelegate
            mcNearbyServiceAdvertiser.startAdvertisingPeer()
        } else {
            mcNearbyServiceAdvertiser.stopAdvertisingPeer()
        }
    }
    
    
    func sendData(dataDictionary: [String: Any]) {
        if mcSession.connectedPeers.count > 0 {
            do {
                var data = Data()
                
                if dataDictionary.keys.contains("game"), dataDictionary.keys.contains("isLoading") {

                    var newDict = dataDictionary
                    let game = newDict["game"] as! Game
                    
                    let jsonEncoder = JSONEncoder()
                    let encodedGame = try jsonEncoder.encode(game)
                    let gameAsString = String(decoding: encodedGame, as: UTF8.self)
                    
                    newDict["game"] = gameAsString
                    
                    data = convertDictionaryToData(dictionary: newDict)!
                    
                } else if dataDictionary.keys.contains("stop") {
//                    Adapt this part of the condition for the STOP
                    data = convertDictionaryToData(dictionary: dataDictionary)!
                }
                
                try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
                
            } catch {
                Alert.shared.showSendError(on: UIApplication.getTopViewController()!, message: error.localizedDescription)
            }
        }
    }
    
    func getGameID(dictionary: [String: Any]?) -> String? {
        guard let dataDictionary = dataToReceive else { return nil }
        let id = dataDictionary["gameID"] as? String
        return id
    }
    
    func convertDataToDictionary(data: Data) -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func convertDictionaryToData(dictionary: [String: Any]) -> Data? {
        do {
            // here "jsonData" is the dictionary encoded in JSON data
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            return jsonData
            
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
}


// MARK: - SESSION DELEGATE
extension ConnectionManager: MCSessionDelegate {
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
            let dict = self?.convertDataToDictionary(data: data)
            
            if (dict?.keys.contains("stop"))!, (dict?.keys.contains("notification"))! {
                
//                TODO: THE FLAG TO STOP THE GAME
                print("Dictionary: ", dict!)
                
            } else {
                
                do {
                    
                    let gameSetupViewController = UIApplication.getTopViewController() as! GameSetupViewController
                    let notification = dict!["isLoading"] as! Bool
                    
                    let gameAsString = dict!["game"] as! String
                    let gameToDecode = Data(gameAsString.utf8)
                    
                    let jsonDecoder = JSONDecoder()
                    let game = try jsonDecoder.decode(Game.self, from: gameToDecode)
                    
                    gameSetupViewController.completionHandler!(notification, game)
                } catch {
                    Alert.shared.showReceptionError(on: UIApplication.getTopViewController()!, message: error.localizedDescription)
                }
            }
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    }
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
}
