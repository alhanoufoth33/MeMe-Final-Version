//
//  Meme.swift
//  IOS-MeMeV1
//
//  Created by Alhanouf AlOthman on 05/10/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
     struct Meme {
          let topText: String?
          let bottomText: String?
          let originalImage: UIImage?
        let memedImage: UIImage?


init(topText: String, bottomText: String, originalImage: UIImage?, memedImage: UIImage?) {
  self.topText = topText
  self.bottomText = bottomText
  self.originalImage = originalImage
  self.memedImage = memedImage
}
}
    
   
