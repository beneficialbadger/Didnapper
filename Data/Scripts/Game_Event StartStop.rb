#==============================================================================
# ** Game_Event StartStop
#------------------------------------------------------------------------------
#  Extension of Game_Event to temporarily stop movement of events.
#
#  Please note: it will most like not propagate between pages well,
#  so make sure to restart before the event changes page.
#==============================================================================

def stop_moving(ev_id)
  event = $game_map.events[ev_id]
  event.stop_moving
end

def restart_moving(ev_id)
  event = $game_map.events[ev_id]
  event.restart_moving
end

class Game_Event
  def stop_moving
    refresh
    @old_move_type = @move_type
    @move_type = 0
    @page.move_type = 0
  end
  def restart_moving
    if @old_move_type != nil
      @move_type = @old_move_type
      @page.move_type = @old_move_type
    end
  end
end
