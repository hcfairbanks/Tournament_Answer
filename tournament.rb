class Tournament
  @score_template = { mp: 0, win: 0, loss: 0, draw: 0, points: 0 }

  def self.tally(game_results)
    if !game_results.empty?
      scores = Hash.new {|h,k| h[k]= @score_template }
      games = game_results.split("\n");
      games.each do | game |
        game_data = game.split(";")
        team_0, team_1 = self.clone_and_increment_game(scores, game_data)
        score_game(team_0,team_1, game_data)
        scores[game_data[0]] = team_0
        scores[game_data[1]] = team_1
      end
    else
      scores = []
    end
    return self.print_board(scores)
  end

  def self.clone_and_increment_game(scores, game_data)
    team_0 = scores[game_data[0]].clone
    team_1 = scores[game_data[1]].clone
    team_0[:mp] +=1
    team_1[:mp] +=1
    return team_0, team_1
  end

  def self.score_game(team_0, team_1, game_data)
    case game_data[2]
    when "win"
      team_0[:win] += 1
      team_0[:points] += 3
      team_1[:loss] += 1
    when "loss"
      team_0[:loss] += 1
      team_1[:points] += 3
      team_1[:win] += 1
    else
      team_0[:draw] += 1
      team_1[:draw] += 1
      team_0[:points] += 1
      team_1[:points] += 1    
    end
  end

  def self.print_board(scores)
    name_spaces = 31
    board = "Team#{" " * (name_spaces - "Team".length)}" +
            "| MP |  W |  D |  L |  P\n"
    sorted_scores = scores.sort_by { |k, v|  [ -v[:points], -k]  }

    sorted_scores.each do | key, val|
      board += "#{key}#{" " * (name_spaces - key.length) }| " +
               " #{val[:mp]} |  #{val[:win]} | " +
               " #{val[:draw]} |  #{val[:loss]} |  #{val[:points]}\n"
    end
    board
  end
end