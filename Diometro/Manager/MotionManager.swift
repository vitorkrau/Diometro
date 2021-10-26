//
//  MotionManager.swift
//  Diometro
//
//  Created by Vitor Krau on 22/09/20.
//

import CoreMotion


class MotionManager: ObservableObject{
    var motionManager = CMMotionManager()
    @Published var z: Double = 0
    
    init(){
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates()
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            if let myData = data{
                self.z = myData.acceleration.z
            }
        }
    }
}




