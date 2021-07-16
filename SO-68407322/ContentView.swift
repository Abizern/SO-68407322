//
//  ContentView.swift
//  SO-68407322
//
//  Created by Abizer Nasir on 16/07/2021.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    enum ViewState {
        case initial
        case loading
        case login
        case menu
    }
    @Published var username = ""
    @Published var password = ""
    @Published var viewState = ViewState.initial

    var loginButtonDisabled: Bool {
        username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty  ||
            password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func goToLogin() {
        viewState = .login
    }

    func login() {
        viewState = .loading
        // I'm not actually logging in, just randomly simulating either a successful or unsuccessful login after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if Bool.random() {
                self.viewState = .menu
            } else {
                self.viewState = .login
            }
        }
    }
}

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()

    var body: some View {
        ZStack {
            initialView
            loginView
            loadingView
            menuView
        }
    }

    private var initialView: InitialView? {
        guard .initial ==  viewModel.viewState else { return nil }
        return InitialView(viewModel: viewModel)
    }

    private var loginView: LoginView? {
        guard .login == viewModel.viewState else { return nil }
        return LoginView(viewModel: viewModel)
    }

    private var loadingView: LoadingView? {
        guard .loading == viewModel.viewState else { return nil }
        return LoadingView()
    }

    private var menuView: MenuView? {
        guard .menu == viewModel.viewState else { return nil }
        return MenuView()
    }

}

struct InitialView: View {
    @ObservedObject var viewModel: ContentViewModel
    var body: some View {
        VStack {
            Text("Initial View")
                .font(.largeTitle)
                .padding()
            Button("Login") { viewModel.goToLogin() }

        }
    }
}

struct LoginView: View {
    @ObservedObject var viewModel: ContentViewModel
    var body: some View {
        VStack {
            Text("Login View")
                .font(.largeTitle)
                .padding()
            TextField("Username", text: $viewModel.username)
                .padding()
            TextField("Password", text: $viewModel.password)
                .padding()
            Button("Login") {viewModel.login() }
                .padding()
                .disabled(viewModel.loginButtonDisabled)
        }
    }
}

struct LoadingView: View {
    var body: some View {
        Text("Loading View")
            .font(.largeTitle)
    }
}

struct MenuView: View {
    var body: some View {
        Text("Menu View")
            .font(.largeTitle)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
