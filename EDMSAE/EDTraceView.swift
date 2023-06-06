//
//  EDTraceView.swift
//  Pods
//
//  Created by Jason Zhang on 2023/6/4.
//

import Foundation
import UIKit

class EDTraceView: UIView {
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var traceLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    func setupUI() {
        addSubview(dateLabel)
        addSubview(traceLabel)

        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.left.equalToSuperview().offset(6)
        }
        traceLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-6)
            make.right.equalToSuperview().offset(-6)
            make.left.equalToSuperview().offset(6)
        }
        traceLabel.numberOfLines = 2
    }

    func setupEvent(trace: Trace) {
        dateLabel.text = trace.acceptTime
        traceLabel.text = trace.action
    }
}
