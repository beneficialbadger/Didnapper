#==============================================================================
# ** Game_Character (part 3)
#------------------------------------------------------------------------------
#  This class deals with characters. It's used as a superclass for the
#  Game_Player and Game_Event classes.
#==============================================================================

class Game_Character
   def turn_toward_event(id)
    # Get difference in player coordinates
    sx = @x - $game_map.events[id].x
    sy = @y - $game_map.events[id].y
    # If coordinates are equal
    if sx == 0 and sy == 0
      return
    end
    # If horizontal distance is longer
    if sx.abs > sy.abs
      # Turn to the right or left towards player
      sx > 0 ? turn_left : turn_right
    # If vertical distance is longer
    else
      # Turn up or down towards player
      sy > 0 ? turn_up : turn_down
    end
  end
end
