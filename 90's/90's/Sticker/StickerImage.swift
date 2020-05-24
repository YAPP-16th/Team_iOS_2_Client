//
//  StickerImage.swift
//  90's
//
//  Created by 성다연 on 2020/05/22.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Foundation

let StickerDatabase : StickerModel = StickerModel()

class StickerModel {
    let arrayList : [StickerImage] = [.Basic, .Glitter, .Character, .Tape, .Words, .Alphabet, .Number]
}

enum StickerImage {
    case Basic
    case Glitter
    case Character
    case Tape
    case Words
    case Alphabet
    case Number
    
    var imageArray : [UIImage] {
        switch self {
        case .Basic : return [
            UIImage(named: "basic_sticker_ribbon_3")!, UIImage(named: "basic_sticker_ribbon_4")!,
            UIImage(named: "basic_sticker_ribbon_6")!, UIImage(named: "basic_sticker_ribbon_5")!,
            UIImage(named: "basic_sticker_light_grey")!, UIImage(named: "basic_sticker_light_yellow")!,
            UIImage(named: "basic_sticker_butterfly_white")!, UIImage(named: "basic_sticker_butterfly_lilac")!,
            UIImage(named: "basic_sticker_butterfly_blue")!, UIImage(named: "basic_sticker_heart_black")!,
            UIImage(named: "basic_sticker_heart_pink")!, UIImage(named: "basic_sticker_heart_red")!,
            UIImage(named: "basic_sticker_star_white")!, UIImage(named: "basic_sticker_star_yellow")!,
            UIImage(named: "basic_sticker_gift_blue")!, UIImage(named: "basic_sticker_gift_pink")!,
            UIImage(named: "basic_sticker_gift_red")!, UIImage(named: "basic_sticker_flower_yellow")!,
            UIImage(named: "basic_sticker_flower_blue")!, UIImage(named: "basic_sticker_flower_red")! ]
        case .Glitter : return [
            UIImage(named: "glitter_sticker_smile_yellow")!, UIImage(named: "glitter_sticker_smile_orange")!,
            UIImage(named: "glitter_sticker_smile_green")!, UIImage(named: "glitter_sticker_smile_blue")!,
            UIImage(named: "glitter_sticker_ribbon_1")!, UIImage(named: "glitter_sticker_ribbon_2")!,
            UIImage(named: "glitter_sticker_bear_yellow")!, UIImage(named: "glitter_sticker_bear_pink")!,
            UIImage(named: "glitter_sticker_glitter_heart_yellow")!, UIImage(named: "glitter_sticker_glitter_heart_blue")!,
            UIImage(named: "glitter_sticker_glitter_heart_pink")!, UIImage(named: "glitter_sticker_glitterstar_yellow")!,
            UIImage(named: "glitter_sticker_glitterstar_orange")!, UIImage(named: "glitter_sticker_glitterstar_red")!,
            UIImage(named: "glitter_sticker_glitterstar_blue")!, UIImage(named: "glitter_sticker_glitterstar_green")!]
        case .Character : return [
            UIImage(named: "character_sticker_rabbit")!, UIImage(named: "character_sticker_dog")!,
            UIImage(named: "character_sticker_white")!, UIImage(named: "character_sticker_cat_grey")!,
            UIImage(named: "character_sticker_sunflower")!, UIImage(named: "character_sticker_tulip")!,
            UIImage(named: "character_sticker_bear_heart_skyblue")!, UIImage(named: "character_sticker_bear_gift")!,
            UIImage(named: "character_sticker_bear_apple_skyblue")!, UIImage(named: "character_sticker_bear_ribbon_salmon")!,
            UIImage(named: "character_sticker_bear_ribbon_skyblue")!, UIImage(named: "character_sticker_bear_ribbon_pink")!,
            UIImage(named: "character_sticker_bear_ribbon_lilac")!, UIImage(named: "character_sticker_bear_ribbon_babypink")!
            ]
        case .Tape : return [
            UIImage(named: "tape_sticker_masking_tape1")!, UIImage(named: "tape_sticker_masking_tape2")!,
            UIImage(named: "tape_sticker_masking_tape3")!, UIImage(named: "tape_sticker_masking_tape4")!,
            UIImage(named: "tape_sticker_masking_tape5")!, UIImage(named: "tape_sticker_masking_tape6")!,
            UIImage(named: "tape_sticker_masking_tape7")!, UIImage(named: "tape_sticker_masking_tape8")!,
            UIImage(named: "tape_sticker_masking_tape10")!, UIImage(named: "tape_sticker_masking_tape9")!,
            UIImage(named: "tape_sticker_masking_tape11")!, UIImage(named: "tape_sticker_masking_tape13")!,
            UIImage(named: "tape_sticker_masking_tape12")!, UIImage(named: "tape_sticker_masking_tape14")!
            ]
        case .Words : return [
            UIImage(named: "words_sticker_relax")!, UIImage(named: "words_sticker_foreveryoung")!,
            UIImage(named: "words_sticker_love")!, UIImage(named: "words_sticker_dailylife")!,
            UIImage(named: "words_sticker_myholiday")!, UIImage(named: "words_sticker_friendship")!,
            UIImage(named: "words_sticker_90svibe")!, UIImage(named: "words_sticker_hbd")!,
            UIImage(named: "words_sticker_ordinary")!, UIImage(named: "words_sticker_lovelyday")!
            ]
        case .Alphabet : return [
            UIImage(named: "alphabet_sticker_a")!, UIImage(named: "alphabet_sticker_b")!,
            UIImage(named: "alphabet_sticker_c")!, UIImage(named: "alphabet_sticker_d")!,
            UIImage(named: "alphabet_sticker_e")!, UIImage(named: "alphabet_sticker_f")!,
            UIImage(named: "alphabet_sticker_g")!, UIImage(named: "alphabet_sticker_h")!,
            UIImage(named: "alphabet_sticker_i")!, UIImage(named: "alphabet_sticker_j")!,
            UIImage(named: "alphabet_sticker_k")!, UIImage(named: "alphabet_sticker_l")!,
            UIImage(named: "alphabet_sticker_m")!, UIImage(named: "alphabet_sticker_n")!,
            UIImage(named: "alphabet_sticker_o")!, UIImage(named: "alphabet_sticker_p")!,
            UIImage(named: "alphabet_sticker_q")!, UIImage(named: "alphabet_sticker_r")!,
            UIImage(named: "alphabet_sticker_s")!, UIImage(named: "alphabet_sticker_t")!,
            UIImage(named: "alphabet_sticker_u")!, UIImage(named: "alphabet_sticker_v")!,
            UIImage(named: "alphabet_sticker_w")!, UIImage(named: "alphabet_sticker_x")!,
            UIImage(named: "alphabet_sticker_y")!, UIImage(named: "alphabet_sticker_z")!
            ]
        case .Number : return [
            UIImage(named: "number_stickerthumb_0")!, UIImage(named: "number_stickerthumb_1")!,
            UIImage(named: "number_stickerthumb_2")!, UIImage(named: "number_stickerthumb_3")!,
            UIImage(named: "number_stickerthumb_4")!, UIImage(named: "number_stickerthumb_5")!,
            UIImage(named: "number_stickerthumb_6")!, UIImage(named: "number_stickerthumb_7")!,
            UIImage(named: "number_stickerthumb_8")!, UIImage(named: "number_stickerthumb_9")!
            ]
        }
    }
}


