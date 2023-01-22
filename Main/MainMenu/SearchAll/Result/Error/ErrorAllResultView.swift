//
//  ErrorAllResultView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 19.01.2023.
//

import SwiftUI

struct ErrorAllResultView: View {
    let error: RequestError
    
    var body: some View {
        switch error {
        case .addressUnreachable:
            Text(".addressUnreachable")
        case .invalidRequest:
            NoScheduleView()
                
        case .decodingError:
            Text(".decodingError")
        case .timeOut:
            Text(".timeOut")
        }
    }
}

struct ErrorAllResultView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorAllResultView(error: RequestError.addressUnreachable)
    }
}
