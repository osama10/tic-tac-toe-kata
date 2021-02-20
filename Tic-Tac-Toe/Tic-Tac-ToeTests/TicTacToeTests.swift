//
//  TicTacToe.swift
//  Tic-Tac-ToeTests
//
//  Created by Osama Bashir on 2/20/21.
//

import XCTest
@testable import Tic_Tac_Toe

final class TicTacToe {

    enum TicTacToeError: Error {
        case alreadyOccupied
        case wrongPosition
    }

    struct Position {
        let row: Int
        let col: Int
    }

    enum Player: String {
        case playerX = "X"
        case playerO = "O"
    }

    enum Status: Equatable {
        case win(Player)

        static func ==(lhs: Status, rhs: Status) -> Bool {
            switch (lhs, rhs) {
            case (let .win(lhsPlayer), let .win(rhsPlayer)) where lhsPlayer == rhsPlayer: return true
            default:
                return false
            }
        }
    }

    private var board : [[String]]
    private var lastPlayer: Player? = nil

    init() { board = Array(repeating: Array(repeating: "", count: 3), count: 3) }

    func numberOfPossibleMoves() -> Int {
        board.reduce(into: 0, checkPossibleMovesInARow)
    }

    func makeMove(position: Position, player: Player) throws {
        try canMakeAMove(position: position)
        board[position.row][position.col] = player.rawValue
        lastPlayer = player
    }

    /// TODO: start from here
    func status() -> Status { Status.win(.playerX) }

    private func canMakeAMove(position: Position) throws {
        guard position.row >= 0 && position.row < 3 else { throw TicTacToeError.wrongPosition }
        guard position.col >= 0 && position.col < 3 else { throw TicTacToeError.wrongPosition }
        guard board[position.row][position.col].isEmpty else { throw TicTacToeError.alreadyOccupied }
    }

    private func checkPossibleMovesInARow(prevResult: inout Int,row: [String]) {
        prevResult += row.filter{ $0.isEmpty }.count
    }
}

class TicTacToeTests: XCTestCase {

    func test_total_number_of_moves_possible_is_9_when_game_is_started() {
        let game = TicTacToe()
        XCTAssertEqual(game.numberOfPossibleMoves(), 9)
    }

    func test_if_player_can_make_a_move() {
        let game = TicTacToe()
        XCTAssertNoThrow(try game.makeMove(position: .init(row: 0, col: 2), player: .playerX ))
        XCTAssertNoThrow(try game.makeMove(position: .init(row: 0, col: 1), player: .playerO ))

    }

    func test_when_player_select_occupied_position_then_player_cannot_make_move() {
        let game = TicTacToe()
        XCTAssertNoThrow(try game.makeMove(position: .init(row: 0, col: 2), player: .playerX ))
        XCTAssertThrowsError(try game.makeMove(position: .init(row: 0, col: 2), player: .playerO))
    }

    func test_when_player_select_wrong_position_then_player_cannot_make_move() {
        let game = TicTacToe()

        XCTAssertThrowsError(try game.makeMove(position: .init(row: Int.random(in: 0...2), col: Int.random(in: 3...Int.max)), player: .playerX ))
        XCTAssertThrowsError(try game.makeMove(position: .init(row: Int.random(in: 0...2), col: Int.random(in: Int.min...(-1))), player: .playerX ))

        XCTAssertThrowsError(try game.makeMove(position: .init(row: Int.random(in: 3...Int.max), col: Int.random(in: 0...2)), player: .playerX ))
        XCTAssertThrowsError(try game.makeMove(position: .init(row: Int.random(in: Int.min...(-1)), col: Int.random(in: 0...2)), player: .playerX ))
    }

    /// TODO: start from here
    func test_when_player_make_winmove_then_game_finishes_with_player_as_winner() {
        let game = TicTacToe()
        let status = game.status()
        XCTAssertEqual(status, .win(.playerX))
    }

}
