//
//  WaterBalanceModel.swift
//  ActiveMe
//
//  Created by Dzmitry Semianovich on 12/3/21.
//

import Foundation

struct Item: Hashable {
    let title: String?
    let emojiIcon: String?
    private let id = UUID()
}

struct DrinksSection {
    let header: Item
    var items = [Item]()
}

class WaterBalanceListModel {
    enum SectionsTitles: String {
        case Water
        case Tea
        case Sports = "Sports drinks"
        case Food
        case Alcohol = "Alcoholic beverages"
        case Other = "Other beverages"
        
        init(sectionIdx: Int) {
            switch sectionIdx {
            case 0:
                self = .Water
            case 1:
                self = .Tea
            case 2:
                self = .Sports
            case 3:
                self = .Food
            case 4:
                self = .Alcohol
            case 5:
                self = .Other
            default:
                self = .Other
            }
        }
    }
    
    enum Drinks: String {
        case Borjomi
        case Water
        case StrongBlackTea = "String black tea"
        case StrongGreenTea = "String green tea"
        case FruitTea = "Fruit tea"
        case Fitness = "Fitness and nutrition shake"
        case Sport = "Sport energy drink"
        case Cocoa = "Hot cocoa or chocolate"
        case BerryDrink = "Fresh berry drink"
        case FruitDrink = "Dried & fresh fruit drink"
        case Yoghurt
        case Ayran
        case MilkShake = "Milk shake"
        case WhileDry = "White dry wine"
        case RedDry = "Red dry wine"
        case WhileSemi = "White semi-sweet wine"
        case RedSemi = "Red semi-sweet wine"
        case Cocktail
        case Energy = "Energy drink"
        case Soft = "Carbonated soft drink"
    }
    
    func configureSections() -> [DrinksSection] {
        var drinksSections = [DrinksSection]()
        for sectionIdx in 0...5 {
            var section = DrinksSection(header: Item(title: SectionsTitles(sectionIdx: sectionIdx).rawValue, emojiIcon: nil))
            section.items = configureItems(for: sectionIdx)
            drinksSections.append(section)
        }
        
        return drinksSections
    }
    
    private func configureItems(for sectionIdx: Int) -> [Item] {
        var items = [Item]()
        
        switch sectionIdx {
        case 0:
            items += [Item(title: Drinks.Water.rawValue, emojiIcon: "💧"),
                      Item(title: Drinks.Borjomi.rawValue, emojiIcon: "💦")]
        case 1:
            items += [Item(title: Drinks.StrongBlackTea.rawValue, emojiIcon: "☕️"),
                      Item(title: Drinks.StrongGreenTea.rawValue, emojiIcon: "🍵"),
                      Item(title: Drinks.FruitTea.rawValue, emojiIcon: "🫖")]
        case 2:
            items += [Item(title: Drinks.Sport.rawValue, emojiIcon: "⚽️"),
                      Item(title: Drinks.Fitness.rawValue, emojiIcon: "🏃🏼")]
        case 3:
            items += [Item(title: Drinks.Cocoa.rawValue, emojiIcon: "🍫"),
                      Item(title: Drinks.BerryDrink.rawValue, emojiIcon: "🍓"),
                      Item(title: Drinks.FruitDrink.rawValue, emojiIcon: "🍒"),
                      Item(title: Drinks.Yoghurt.rawValue, emojiIcon: "🥛")]
        case 4:
            items += [Item(title: Drinks.RedDry.rawValue, emojiIcon: "🍷")]
        case 5:
            items += [Item(title: Drinks.Energy.rawValue, emojiIcon: "⚡️")]
        default :
            break
        }
        
        return items
    }
}
