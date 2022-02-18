//
//  ViewController.swift
//  ConnectTheDots
//
//  Created by Manish Kumar on 2022-02-17.
//

import UIKit

class ViewController: UIViewController {
    var numCircles = 5
    var connections = [ConnectionView]()
    let renderLinesImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        
        /// It's important to add the background image view first so that the lines are drawn underneath the circles.
        renderLinesImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(renderLinesImageView)
        
        NSLayoutConstraint.activate([
            renderLinesImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            renderLinesImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            renderLinesImageView.topAnchor.constraint(equalTo: view.topAnchor),
            renderLinesImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        drawAndPlaceCircles()
    }
    
    func drawAndPlaceCircles() {
        connections.forEach { view in
            view.removeFromSuperview()
        }
        connections.removeAll()
        
        for _ in 1...numCircles {
            let connection = ConnectionView(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
            connection.backgroundColor = .white
            connection.layer.cornerRadius = 22
            connection.layer.borderWidth = 2
            connections.append(connection)
            view.addSubview(connection)
            connection.connectionDragged = { [weak self] in
                self?.redrawLines()
            }
        }
        
        /// Create a circular linked list.
        for i in 0 ..< connections.count {
            if i == connections.count - 1 {
                // this is the last connection; join it back to the first one
                connections[i].nextConnection = connections[0]
            } else {
                connections[i].nextConnection = connections[i+1]
            }
        }
        
        connections.forEach(place)
        redrawLines()
    }
    
    /// Randomly place the circles but make sure that they are a little bit away from the screen edges.
    func place(_ connection: ConnectionView) {
        let randomX = CGFloat.random(in: 20...view.bounds.maxX - 20)
        let randomY = CGFloat.random(in: 50...view.bounds.maxY - 50)
        connection.center = CGPoint(x: randomX, y: randomY)
    }
    
    func redrawLines() {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        let pattern: [CGFloat] = [4,4] /// Draw a dotted line
        
        renderLinesImageView.image = renderer.image { ctx in
            ctx.cgContext.setLineDash(phase: 0, lengths: pattern)
            for connection in connections {
                UIColor.green.set()
                ctx.cgContext.strokeLineSegments(between: [connection.nextConnection.center, connection.center])
            }
        }
    }
}
