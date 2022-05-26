//
//  DataRepresentable.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/16/22.
//

import Foundation
import CoreGraphics

protocol DataRepresentable {
    func points(forData data: [Double], frame: CGRect, offset: Double, lineWidth: CGFloat) -> [CGPoint]
    func lineWidth(visualType: ChartVisualType) -> CGFloat
}

extension DataRepresentable {

    func points(forData data: [Double], frame: CGRect, offset: Double, lineWidth: CGFloat) -> [CGPoint] {
        var vector = Math.stretchOut(Math.norm(data))
        if offset != 0 {
            vector = Math.stretchIn(vector, offset: offset)
        }
        var points: [CGPoint] = []
        let isSame = sameValues(in: vector)
        for iii in 0..<vector.count {
            let xxxx = frame.size.width / CGFloat(vector.count - 1) * CGFloat(iii)
            let yyyy = isSame ? frame.size.height / 2 : (frame.size.height - lineWidth) * CGFloat(vector[iii]) + lineWidth / 2
            points.append(CGPoint(x: xxxx, y: yyyy))
        }

        return points
    }

    func lineWidth(visualType: ChartVisualType) -> CGFloat {
        switch visualType {
        case .outline(_, let lineWidth):
            return lineWidth
        case .filled(_, let lineWidth):
            return lineWidth
        case .customFilled(_, let lineWidth, _):
            return lineWidth
        }
    }

    private func sameValues(in vector: [Double]) -> Bool {
        guard let prev = vector.first else { return true }

        for value in vector {
            if value != prev { return false }
        }

        return true
    }
}
