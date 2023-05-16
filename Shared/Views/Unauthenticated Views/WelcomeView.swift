//
//  WelcomeView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import ModelIO
import UIKit
import SwiftUI
import Stinsen
import Colorful
import SceneKit

struct WelcomeView: View {

    @EnvironmentObject private var unauthenticatedRouter: UnauthenticatedCoordinator.Router

    @ObservedObject private var store: UnauthenticatedServices

    @State var showSheet: Bool = false

    init(services: UnauthenticatedServices) {
        self.store = services
    }

    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center, spacing: 10) {
                ZStack(alignment: .topLeading) {
                    HStack(spacing: 10) {
    //                    SceneView(scene: SCNScene(named: "Earth"), options: [.autoenablesDefaultLighting, .allowsCameraControl])
    //                        .frame(width: 80, height: 80)
    //                        .background(.clear)

                        SceneKitView(name: "Earth")
                            .frame(width: 65, height: 65)
                            .padding(.leading)

                        Spacer()
                    }

                    MainCarouselView()
                }
                .padding(.bottom, 10)


                VStack(alignment: .center, spacing: 20) {
                    RoundedButton("Create New Wallet", style: .primary, systemImage: "paperplane.fill", action: {
                        guard store.unauthenticatedWallet.address == "" else {
                            showSheet.toggle()
                            return
                        }

                        unauthenticatedRouter.route(to: \.generateWallet)
                        #if os(iOS)
                            HapticFeedback.rigidHapticFeedback()
                        #endif
                    })

                    Button("Import Wallet") {
                        unauthenticatedRouter.route(to: \.importWallet)
                        #if os(iOS)
                            HapticFeedback.lightHapticFeedback()
                        #endif
                    }
                    .padding(.vertical, 10)
                }
                .background(bottomGradientView(geo))
            }.background(ColorfulView(animation: Animation.easeInOut(duration: 10), colors: [.red, .pink, .purple, .blue]))
            .confirmationDialog("Abandon generated address?",
                                isPresented: $showSheet,
                                titleVisibility: .visible) {
                Button("Continue") {
                    unauthenticatedRouter.route(to: \.privateKeys)
                }

                Button("New Wallet", role: .destructive) {
                    store.unauthenticatedWallet = Wallet(address: "", data: Data(), name: "", isHD: true)
                    unauthenticatedRouter.route(to: \.generateWallet)

                    #if os(iOS)
                        HapticFeedback.rigidHapticFeedback()
                    #endif
                }
            } message: {
                Text("We notice you have generated \(store.unauthenticatedWallet.name).\nKeep current address or generate a new address?")
            }
        }.background(AppGradients.purpleGradient)
        #if os(iOS)
        .navigationViewStyle(StackNavigationViewStyle())
        #endif
    }

    @ViewBuilder
    func bottomGradientView(_ proxy: GeometryProxy) -> some View {
        Rectangle().fill(AppGradients.backgroundFade)
            .frame(width: proxy.size.width, height: 140)
            .frame(maxWidth: .infinity, alignment: .center)
            .offset(y: 20)
            .edgesIgnoringSafeArea(.vertical)
    }

}


struct SceneKitView: UIViewRepresentable {
    var name: String

    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        
        // Set up the scene
        let scene = SCNScene()
        scnView.scene = scene
        
        // Set clear background
        scnView.backgroundColor = UIColor.clear
        
        var modelNode: SCNNode?
            if let modelURL = Bundle.main.url(forResource: name, withExtension: "usdz") {
                do {
                    let modelScene = try SCNScene(url: modelURL, options: [.convertToYUp: true, .convertUnitsToMeters: true])
                    modelNode = modelScene.rootNode.childNodes.first
                    if let node = modelNode {
                        // Scale the model to fit the view
//                        node.setModelScale(scale: 0.1) // Adjust the scale value as needed

                        // Add the model to the scene
                        scene.rootNode.addChildNode(node)
                        
                        // Start the constant spin
                        node.startRotation(duration: 30)
                    }
                } catch {
                    print("Error loading the .usdz file: \(error.localizedDescription)")
                }
            }
//
//        let cameraNode = SCNNode()
//        cameraNode.camera = SCNCamera()
//        cameraNode.position = SCNVector3(x: 0, y: 0, z: 20)
//        scene.rootNode.addChildNode(cameraNode)
//        
        // Set up lighting
//        let lightNode = SCNNode()
//        lightNode.light = SCNLight()
//        lightNode.light?.type = .omni
//        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
//        scene.rootNode.addChildNode(lightNode)
//        
        // Set up ambient light
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.color = UIColor(white: 0.8, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)

        // Set up a pan gesture recognizer for user interaction
        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(SceneSpinCoordinator.handlePanGesture(_:)))
        scnView.addGestureRecognizer(panGesture)
        
        scnView.allowsCameraControl = true

        return scnView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        // Update the view as needed
    }
}


extension SCNNode {
    func scaleToFit(viewSize: CGSize) {
        let (min, max) = boundingBox
        let modelSize = SCNVector3(max.x - min.x, max.y - min.y, max.z - min.z)
        
        let scaleX = Float(viewSize.width) / modelSize.x
        let scaleY = Float(viewSize.height) / modelSize.y
        let scale = Swift.min(scaleX, scaleY)
        
        self.scale = SCNVector3(scale, scale, scale)
    }
    
    func startRotation(duration: TimeInterval = 40) {
        let rotationAction = SCNAction.rotateBy(x: 0, y: CGFloat.pi * 2, z: 0, duration: duration)
        let repeatAction = SCNAction.repeatForever(rotationAction)
        runAction(repeatAction)
    }
    
    func setModelScale(scale: Float) {
        self.scale = SCNVector3(x: scale, y: scale, z: scale)
    }

}

class SceneSpinCoordinator: NSObject {
    var modelNode: SCNNode?
    var startAngle: Float = 0.0
    
    init(modelNode: SCNNode?) {
        self.modelNode = modelNode
    }
    
    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        guard let modelNode = modelNode else { return }
        
        let translation = sender.translation(in: sender.view)
        let angle = Float(translation.x) * Float.pi / 180.0
        
        switch sender.state {
        case .began:
            startAngle = modelNode.eulerAngles.y
        case .changed:
            modelNode.removeAllActions()
            modelNode.eulerAngles.y = startAngle + angle
        case .ended:
            modelNode.startRotation()
        default:
            break
        }
    }
}
