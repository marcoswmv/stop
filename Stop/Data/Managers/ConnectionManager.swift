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
                    
                } else if dataDictionary.keys.contains("player"), dataDictionary.keys.contains("stop") {
                    
                    var newDict = dataDictionary
                    let player = newDict["player"] as! Player
                    
                    let jsonEncoder = JSONEncoder()
                    let encodedPlayer = try jsonEncoder.encode(player)
                    let playerAsString = String(decoding: encodedPlayer, as: UTF8.self)
                    
                    newDict["player"] = playerAsString
                    
                    data = convertDictionaryToData(dictionary: newDict)!
                }
                
                try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
                
            } catch {
                Alert.shared.showSendError(on: UIApplication.getTopViewController()!, message: error.localizedDescription)
            }
        }
    }
    
    func convertDataToDictionary(data: Data) -> [String: Any]? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            return jsonObject
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
            
            if (dict?.keys.contains("game"))!, (dict?.keys.contains("isReady"))! {
                do {
                    
                    let gameSetupViewController = UIApplication.getTopViewController() as? GameSetupViewController
                    
                    let isReady = dict!["isReady"] as! Bool
                    
                    let gameAsString = dict!["game"] as! String
                    let gameToDecode = Data(gameAsString.utf8)
                    
                    let jsonDecoder = JSONDecoder()
                    let game = try jsonDecoder.decode(Game.self, from: gameToDecode)
                    
                    gameSetupViewController?.completionHandler?(isReady, game)
                } catch {
                    Alert.shared.showReceptionError(on: UIApplication.getTopViewController()!, message: error.localizedDescription)
                }
            } else if (dict?.keys.contains("player"))!, (dict?.keys.contains("stop"))! {
                do {
                    
                    let gameViewController = UIApplication.getTopViewController() as? GameViewController
                    
                    let stop = dict!["stop"] as! Bool
                    
                    let playerAsString = dict!["player"] as! String
                    let playerToDecode = Data(playerAsString.utf8)
                    
                    let jsonDecoder = JSONDecoder()
                    let player = try jsonDecoder.decode(Player.self, from: playerToDecode)
                    
                    gameViewController?.completionHandler?(player, stop)
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
