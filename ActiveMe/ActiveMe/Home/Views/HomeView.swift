//
//  HomeView.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 13.05.22.
//

import SwiftUI

struct HomeView: View {
  @State var currentWeek: [Date] = []
  @State var currentDay = Date()

  // MARK: - Animation properties
  @State var showViews: [Bool] = Array(repeating: false, count: 5)

  @State var showView: Bool = false
  var body: some View {
    VStack {
      navBar
        .padding(.top, 35)
      dateBar
    ScrollView(.vertical,
               showsIndicators: false) {
      if showView {
        mainContent
      }
    }
    }
    .edgesIgnoringSafeArea(.bottom)
    .padding()
    .frame(maxWidth: .infinity)
    .background(
      background
        .ignoresSafeArea()
    )
    .preferredColorScheme(.dark)
    .onAppear {
      animateViews()
      extractCurrentWeek()

      DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
        showView = true
      }
    }
    .frame(height: UIScreen.main.bounds.height)
  }

  var mainContent: some View {
    VStack(spacing: 5) {
      analitycs
        .padding(.vertical, 15)
        .opacity(showViews[2] ? 1 : 0)
        .offset(y: showViews[2] ? 0 : 200)

      FitnessRingCardView()
        .opacity(showViews[3] ? 1 : 0)
        .offset(y: showViews[3] ? 0 : 250)

      FitnessGraphView()
        .opacity(showViews[4] ? 1 : 0)
        .offset(y: showViews[4] ? 0 : 200)

      Spacer()
        .frame(height: 100)
    }
  }


  var navBar: some View {
    HStack {
      Text("Current week")
        .font(.title)
        .bold()

      Spacer()
    }
    .foregroundColor(.white)
  }

  var dateBar: some View {
    HStack(spacing: 10) {
      ForEach(currentWeek, id: \.self) { day in
        Text(extractDate(date: day))
          .fontWeight(isSameDay(currentDay, day) ? .bold : .semibold)
          .frame(maxWidth: .infinity)
          .padding(.vertical, isSameDay(currentDay, day) ? 6 : 0)
          .padding(.horizontal, isSameDay(currentDay, day) ? 12 : 0)
          .frame(width: isSameDay(currentDay, day) ? 140 : nil)
          .background(
            Capsule()
              .fill(.ultraThinMaterial)
              .environment(\.colorScheme, .light)
              .opacity(isSameDay(currentDay, day) ? 0.8 : 0)
          )
          .onTapGesture {
            withAnimation {
              currentDay = day
            }
          }
      }
    }
  }

  var analitycs: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("Steps")
        .fontWeight(.semibold)

      Text("6,243")
        .font(.system(size: 45, weight: .bold))
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  var background: some View {
    ZStack {
      VStack {
        Circle()
          .fill(Color("bgColorPurple"))
          .scaleEffect(0.7)
          .offset(x: 20)
          .blur(radius: 120)

        Circle()
          .fill(Color("bgColorPurple"))
          .scaleEffect(0.7, anchor: .leading)
          .offset(x: -20)
          .blur(radius: 120)
      }

      Rectangle()
        .fill(.ultraThinMaterial)
    }
  }

  func animateViews() {
    withAnimation(.easeOut) {
      showViews[0] = true
    }

    withAnimation(.easeOut.delay(0.1)) {
      showViews[1] = true
    }

    withAnimation(.easeOut.delay(0.15)) {
      showViews[2] = true
    }

    withAnimation(.easeOut.delay(0.2)) {
      showViews[3] = true
    }

    withAnimation(.easeOut.delay(0.35)) {
      showViews[4] = true
    }
  }


  func extractCurrentWeek() {
    let calendar = Calendar.current
    let week = calendar.dateInterval(of: .weekOfMonth, for: Date())

    guard let firstWeekDay = week?.start else { return }

    (0..<7).forEach { day in
      if let weekDay = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
        currentWeek.append(weekDay)
      }
    }
  }

  func extractDate(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = isSameDay(currentDay, date) ? "dd MMM" : "dd"

    return (isDateToday(date: date) && isSameDay(currentDay, date) ? "Today, " : "") + formatter.string(from: date)
  }

  func isDateToday(date: Date) -> Bool {
    let calendar = Calendar.current

    return calendar.isDateInToday(date)
  }

  func isSameDay(_ lhs: Date, _ rhs: Date) -> Bool {
    let calendar = Calendar.current

    return calendar.isDate(lhs, inSameDayAs: rhs)
  }
}

struct HomeView_prevew: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
