//
//  BadgeView.swift
//  Restaurant
//
//  Created by Mohit Tomar on 14/06/25.
//

//
//  BadgeView.swift
//  Restaurant
//
//  Created by Mohit Tomar on 14/06/25.
//

import SwiftUI

struct BadgeView: View {
    let count: Int

    var body: some View {
        // Only show the badge if the count is greater than 0
        if count > 0 {
            ZStack(alignment: .topTrailing) {
                // An invisible element to take up space and align the badge
                Color.clear
                
                // The badge itself
                Text(String(count))
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .padding(5)
                    .background(Color.red)
                    .clipShape(Circle())
                    // Offset the badge to the top-right corner
                    .offset(x: 12, y: -12)
            }
        }
    }
}
