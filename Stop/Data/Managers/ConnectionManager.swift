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
    
    var receivedGame: Game?
    
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
                
                if dataDictionary.keys.contains("game"), dataDictionary.keys.contains("isReady") {

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
        guard let dataDictionary = receivedGame else { return nil }
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
            return try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
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
            
            if (dict?.keys.contains("game"))!, (dict?.keys.contains("isReady"))! {
                
                do {
                    
                    let gameSetupViewController = UIApplication.getTopViewController() as! GameSetupViewController
                    let isReady = dict!["isReady"] as! Bool
                    
                    let gameAsString = dict!["game"] as! String
                    let gameToDecode = Data(gameAsString.utf8)
                    
                    let jsonDecoder = JSONDecoder()
                    let game = try jsonDecoder.decode(Game.self, from: gameToDecode)
                    
                    self?.receivedGame = game
                    gameSetupViewController.completionHandler?(isReady, game)
                } catch {
                    Alert.shared.showReceptionError(on: UIApplication.getTopViewController()!, message: error.localizedDescription)
                }
            } else if (dict?.keys.contains("stop"))! {
                            
//                TODO: THE FLAG TO STOP THE GAME
                print("Dictionary: ", dict!)
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
