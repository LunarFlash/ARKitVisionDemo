//
//  StableCameraManager.swift
//  ARKitVision
//
//  Created by Terry Wang on 3/19/19.
//  Copyright © 2019 Accenture. All rights reserved.
//

import AVFoundation
import CoreMotion

protocol StableCameraDetectorDelegate {
    func cameraIsStable()
}

class StableCameraDetector {

    private var delegate: StableCameraDetectorDelegate?

    var manager = CMMotionManager()

    func start() {
        guard manager.isAccelerometerAvailable else {
            print("Core Motion accelerometer is not available")
            return }

        //manager.accelerometerUpdateInterval = 0.01

        manager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
            guard let data = data, error == nil else {
                print("Error obtaining accelerometer updates.")
                return
            }

            print("receiving accelerometer data:", data)
        }


    }




}

