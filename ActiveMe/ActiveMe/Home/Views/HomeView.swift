//
//  HomeView.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 13.05.22.
//

import SwiftUI

struct HomeView: View {
  @EnvironmentObject var appViewModel: AppViewModel

  @State var currentWeek: [Date] = []
  @State var currentDay = Date()

  // MARK: - Animation properties
  @State var showViews: [Bool] = Array(repeating: false, count: 5)

  @State var showView: Bool = false

  var body: some View {
    VStack(spacing: 20) {
      navBar
        .padding(.top, 35)
      dateBar
    ScrollView(.vertical,
               showsIndicators: false) {
        mainContent
        .opacity(showView ? 1 : 0)
    }
    }
    .edgesIgnoringSafeArea(.bottom)
    .padding()
    .frame(maxWidth: .infinity)
    .background(
      BackgroundView()
        .ignoresSafeArea()
    )
    .preferredColorScheme(.dark)
    .onAppear {
      appViewModel.fetchHealthDataForDate(currentDay)
      appViewModel.fetchStepsDataForDate(currentDay)
      animateViews()
      extractCurrentWeek()

      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        showView = true
      }
    }
    .onChange(of: currentDay) { date in
      appViewModel.fetchHealthDataForDate(date)
      appViewModel.fetchStepsDataForDate(date)
    }
    .frame(height: UIScreen.main.bounds.height)
  }

  var mainContent: some View {
    VStack(spacing: 20) {
      analitycs
        .padding(.vertical, 15)
        .opacity(showViews[0] ? 1 : 0)
        .offset(y: showViews[0] ? 0 : 200)

      FitnessRingCardView()
        .opacity(showViews[1] ? 1 : 0)
        .offset(y: showViews[1] ? 0 : 250)

      FitnessGraphView()
        .opacity(showViews[2] ? 1 : 0)
        .offset(y: showViews[2] ? 0 : 200)

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

      Image("ActiveMeName")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .foregroundColor(Color("primary"))
        .frame(width: 110, height: 60)
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

      Text(appViewModel.stepsCount)
        .font(.system(size: 45, weight: .bold))
    }
    .frame(maxWidth: .infinity, alignment: .leading)
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
