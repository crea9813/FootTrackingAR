//
//  FootDetector.swift
//  FootTracking
//
//  Created by Yang on 2020/07/08.
//  Copyright © 2020 Minestrone. All rights reserved.
//

import CoreML
import Vision

public class FootDetector {
    
    private let visionQueue = DispatchQueue(label: "com.minestrone.FootTracking.visionqueue")
    
    private lazy var predictionRequest: VNCoreMLRequest = {
        //ML 모델 로딩, Vision request 를 생성
        do {
            let model = try VNCoreMLModel(for: FootModel().model)
            let request = VNCoreMLRequest(model: model)
            
            request.imageCropAndScaleOption = VNImageCropAndScaleOption.scaleFill
            return request
        } catch {
            fatalError("ML 모델 로딩 실패: \(error)")
        }
    }()
    
    public func performDetection(inputBuffer: CVPixelBuffer, completion: @escaping (_ outputBuffer: CVPixelBuffer?, _ error: Error?) -> Void) {
        
        //애플 기기에서 캡처된 이미지의 픽셀데이터는 카메라 센서의 기본 방향으로 인코딩 되기 때문에 .right로 설정
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: inputBuffer, orientation: .right)
        
        //CoreML Requests 를 비동기로 실행
        visionQueue.async {
            do {
                try requestHandler.perform([self.predictionRequest])
                
                guard let observation = self.predictionRequest.results?.first as? VNPixelBufferObservation else {
                    fatalError("Unexpected result type from VNCoreMLRequest")
                }
                
                // 결과 이미지 (마스크 이미지)를 observation.pixelBuffer로 사용가능
                completion(observation.pixelBuffer, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
}
