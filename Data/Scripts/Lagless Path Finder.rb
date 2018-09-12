#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
# Lagless Path Finder by Blizzard
# Version: 1.23
# Type: Pathfinding System
# Date: 9.2.2013
# Date v1.01: 11.4.2013
# Date v1.1: 29.7.2013
# Date v1.2: 7.10.2013
# Date v1.21: 8.10.2013
# Date v1.22: 11.11.2013
# Date v1.23: 28.12.2016 (fix by KK20)
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
#   
#  This work is protected by the following license:
# #----------------------------------------------------------------------------
# #  
# #  Creative Commons - Attribution-NonCommercial-ShareAlike 3.0 Unported
# #  ( http://creativecommons.org/licenses/by-nc-sa/3.0/ )
# #  
# #  You are free:
# #  
# #  to Share - to copy, distribute and transmit the work
# #  to Remix - to adapt the work
# #  
# #  Under the following conditions:
# #  
# #  Attribution. You must attribute the work in the manner specified by the
# #  author or licensor (but not in any way that suggests that they endorse you
# #  or your use of the work).
# #  
# #  Noncommercial. You may not use this work for commercial purposes.
# #  
# #  Share alike. If you alter, transform, or build upon this work, you may
# #  distribute the resulting work only under the same or similar license to
# #  this one.
# #  
# #  - For any reuse or distribution, you must make clear to others the license
# #    terms of this work. The best way to do this is with a link to this web
# #    page.
# #  
# #  - Any of the above conditions can be waived if you get permission from the
# #    copyright holder.
# #  
# #  - Nothing in this license impairs or restricts the author's moral rights.
# #  
# #----------------------------------------------------------------------------
# 
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
# 
# IMPORTANT NOTE:
# 
#   This Path Finder is a derived version of Blizz-ABS's original Path Finder.
#   If you are using Blizz-ABS, please remove this script. Blizz-ABS has a
#   Path Finder already built-in.
# 
# 
# Compatibility:
# 
#   99% compatible with SDK v1.x. 90% compatible with SDK v2.x. May cause
#   incompatibility issues with exotic map systems.
# 
# 
# Features:
# 
#   - calculates path from point A to point B on the map
#   - allows immediate calculation as well as path calculation requests that
#     are done over the course of a few frames in order to reduce lag
#   - supports dynamic calculation that is done every step to ensure the
#     character reaches its targets
#   - can assign other characters as targets so dynamic calculation with a
#     moving will cause the character to find the target regardless of his
#     changed position
# 
# new in v1.01:
#   - fixed attempted optimizations to work properly
# 
# new in v1.1:
#   - fixed a problem with how dyn_request is handled
#   - added PASSABLE parameter for all path finder functions to determine
#     how to behave when using the RANGE parameter
# 
# new in v1.2:
#   - added waypoints
#   - Game_Character#has_path_target? now returns true as well when using
#     target coordinates instead of a target character
# 
# new in v1.21:
#   - added option for loose movement when target cannot be reached
#   - added separate option for debug messages
# 
# new in v1.22:
#   - fixed a problem with waypoints when using range
# 
# new in v1.23:
#   - fixed a problem when DIRECTIONS_8_WAY is turned on
# 
# Instructions:
#   
# - Explanation:
#   
#   This script will allow your characters to walk from point A to point B,
#   navigating by themselves, finding the shortest path and all that without
#   you having to manually specify their moving route. They can also navigate
#   through dynamically changing environments or track a dynamically moving
#   target.
# 
# - Configuration:
# 
#   MAX_NODES_PER_FRAME - maximum number of node calculation per frame when
#                         using path requests instead of immediate calculations
#   DIRECTIONS_8_WAY    - if set to true, it will smooth out corner movement
#                         and use a diagonal movement step wherever possible
#                         (this does NOT mean that the path finder will do
#                         8-directional path finding!)
#   LOOSE_MOVEMENT      - if set to true, it will cause characters to continue
#                         moving when the target cannot be reached for some
#                         reason, following its last movement path (works only
#                         with "dyn" variants)
#   DEBUG_MESSAGES      - if set to true, it will display messages when paths
#                         can't be found
#   
# 
# - Script calls:
# 
#   This path finder offers you several script calls in order to designate path
#   finding to characters on the map. Following script calls are at your
#   disposal:
#   
#     PathFinder.find(C_ID, TARGET[, RANGE[, PASSABLE]])
#     PathFinder.request(C_ID, TARGET[, RANGE[, PASSABLE]])
#     PathFinder.dyn_find(C_ID, TARGET[, RANGE[, PASSABLE]])
#     PathFinder.dyn_request(C_ID, TARGET[, RANGE[, PASSABLE]])
# 
#   C_ID     - either an event ID, 0 for the player character or an actual
#              character (e.g. $game_map.events[ID])
#   TARGET   - an array with X,Y coordinates, an actual target character,
#              an array with arrays of X,Y waypoints or an array of actual
#              character waypoins
#   RANGE    - range within which the target should be located (greater than 0)
#   PASSABLE - when using a range, this is used to determine if the next tile
#              must be passable as well, false by default, used usually when
#              passability between 2 tiles isn't used
#   
#   This is how the 8 different script calls behave:
#   
#   - The "find" variants always calculate the path immediately.
#   - The "request" variants always request a path calculation to be done over
#     the course of several frames in order to avoid lag. Requesting paths for
#     multiple characters will cause the calculation to take longer as each
#     frame only a certain number of nodes is calculated (can be configured).
#     So if there are more characters requesting a path, naturally each one
#     will consume a part of the allowed node calculations every frame.
#   - The "dyn" variants (dynamic) will recalculate/request a calculation every
#     step in order to keep a path up to date with an ever-changing
#     environment. You won't need to use these calls if there are no moving
#     events on the map or if there are no environmental passability changes.
#   - When using a "dyn" variant, if actual coordinates (X, Y) are used, the
#     character will find its path to these fixed coordinates. If an actual
#     target character is being used, the path finder will track the character
#     instead of fixed coordinates. If the character changes its position, the
#     path calculation will attempt to find a path to the new position of the
#     target.
#   - Using "dyn_find" a lot, with many characters at the same time and/or for
#     long paths may cause performance issue and lag. Use it wisely.
#   - Using "dyn_request" is much more performance-friendly, but it will also
#     cause characters to "stop and think". This can also cause problems in a
#     constantly changing environment as the environment may change during the
#     few frames while the calculation is being done. Use it wisely.
#   - In order to queue multiple targets like waypoints, simply call any of the
#     functions as many times as you need.
#   
#   In order to cancel dynamic path calculation for a character, use following
#   script call:
#   
#     character.clear_path_target
#   
#   Example:
#     
#     $game_map.events[23].clear_path_target
#   
#   In order to check if a character has a dynamic path calculation for a
#   target, use following script call:
#   
#     character.has_path_target?
#   
#   Example:
#     
#     if $game_map.events[23].has_path_target?
#   
# 
# Notes:
# 
#   - This path finder is an implementation fo the A* Search Algorithm.
#   - The PathFinder module is being updated during the call of
#     $game_system.update. Keep this in mind if you are using specific exotic
#     scripts.
#   - When using the option LOOSE_MOVEMENT, keep in mind that it doesn't work
#     accurately with dyn_request, because request calculations aren't done
#     immediately like with dyn_find.
# 
# 
# If you find any bugs, please report them here:
# http://forum.chaos-project.com
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# START Configuration
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

module BlizzCFG
  
  MAX_NODES_PER_FRAME = 100
  DIRECTIONS_8_WAY = false
  LOOSE_MOVEMENT = true
  DEBUG_MESSAGES = false
  
end

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# END Configuration
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

$lagless_path_finder = 1.23

#==============================================================================
# module PathFinder
#==============================================================================

module Math
  
  def self.hypot_squared(x, y)
    return (x * x + y * y)
  end
  
end

#==============================================================================
# module PathFinder
#==============================================================================

module PathFinder
  
  PATH_DIRS = [[0, 1, 1], [-1, 0, 2], [1, 0, 3], [0, -1, 4]]
  DIR_DOWN_LEFT = [1, 2]
  DIR_LEFT_DOWN = [2, 1]
  DIR_DOWN_RIGHT = [1, 3]
  DIR_RIGHT_DOWN = [3, 1]
  DIR_LEFT_UP = [2, 4]
  DIR_UP_LEFT = [4, 2]
  DIR_RIGHT_UP = [3, 4]
  DIR_UP_RIGHT = [4, 3]
  DIR_OFFSETS = [[ 0, 0], [0, 1], [-1, 0], [1, 0], [0,-1], 
                 [-1, 1], [1, 1], [-1,-1], [1,-1]]
  
  @requests = {}
  
  def self.clear
    @requests = {}
  end
  
  def self.find(char, target, range = 0, pass = false)
    char, target = self.check_args(char, target, range, pass, false, true)
    self._find(char, target, true)
    return true
  end
  
  def self.dyn_find(char, target, range = 0, pass = false)
    char, target = self.check_args(char, target, range, pass, true, true)
    self._find(char, target, true)
    return true
  end
  
  def self.request(char, target, range = 0, pass = false)
    char, target = self.check_args(char, target, range, pass, false, false)
    self._request(char, target, true)
    return true
  end
  
  def self.dyn_request(char, target, range = 0, pass = false)
    char, target = self.check_args(char, target, range, pass, true, false)
    self._request(char, target, true)
    return true
  end
  
  def self.check_args(char, target, range, pass, dynamic, immediate)
    range = 0 if range == nil || range < 0
    if char.is_a?(Numeric)
      char = (char > 0 ? $game_map.events[char] : $game_player)
    end
    target = PathTarget.new(target, range, pass, dynamic, immediate)
    if $DEBUG && BlizzCFG::DEBUG_MESSAGES && char == nil
      p "Warning! Character to move does not exist!"
    end
    return [char, target]
  end
  
  def self._find(char, target, new = false)
    if @requests[char] == nil && (!char.has_path_target? || !new)
      @requests[char] = PathRequest.new(char.x, char.y, target)
      result = nil
      result = self.calc_node(char) while result == nil
      if $DEBUG && BlizzCFG::DEBUG_MESSAGES && result.size == 0
        p "Warning! Path Finder could not find path for character at (#{target.x},#{target.y})!"
      end
      if !BlizzCFG::LOOSE_MOVEMENT && target.dynamic
        char.set_found_step(result)
      else
        char.set_found_path(result)
      end
    end
    char.add_path_target(target) if new
  end
  
  def self._request(char, target, new = false)
    if @requests[char] == nil
      @requests[char] = PathRequest.new(char.x, char.y, target)
    end
    char.add_path_target(target) if new
  end
  
  def self.update
    @requests = {} if @requests == nil
    characters = @requests.keys
    count = BlizzCFG::MAX_NODES_PER_FRAME
    while characters.size > 0 && count > 0
      char = characters.shift
      dynamic = @requests[char].target.dynamic
      result = self.calc_node(char)
      if result != nil
        if !BlizzCFG::LOOSE_MOVEMENT && dynamic
          char.set_found_step(result)
        else
          char.set_found_path(result)
        end
      else
        characters.push(char)
      end
      count -= 1
    end
  end

  def self.calc_node(char)
    request = @requests[char]
    if request.open.size == 0
      @requests.delete(char)
      return []
    end
    found = false
    key = request.open.keys.min {|a, b|
        a[2] > b[2] ? 1 : (a[2] < b[2] ? -1 :
        (Math.hypot_squared(a[0] - request.target.x, a[1] - request.target.y) <=>
        Math.hypot_squared(b[0] - request.target.x, b[1] - request.target.y)))}
    request.closed[key[0], key[1]] = request.open[key]
    request.open.delete(key)
    kx, ky = 0, 0
    passable = false
    passable_checked = false
    PATH_DIRS.each {|dir|
        kx, ky = key[0] + dir[0], key[1] + dir[1]
        passable = false
        passable_checked = false
        if (kx - request.target.x).abs + (ky - request.target.y).abs <= request.target.range
          if request.target.pass
            passable = char.passable?(key[0], key[1], dir[2]*2)
            passable_checked = true
          else
            passable = true
          end
          if passable
            request.closed[kx, ky] = dir[2]
            found = true
            break
          end
        end
        if request.closed[kx, ky] == 0
          passable = char.passable?(key[0], key[1], dir[2]*2) if !passable_checked
          if passable
            request.open[[kx, ky, key[2] + 1]] = dir[2]
          end
        end}
    return nil if !found
    result = request.backtrack(kx, ky)
    @requests.delete(char)
    return result
  end
  
end

#==============================================================================
# PathTarget
#==============================================================================

class PathTarget
  
  attr_reader :range
  attr_reader :pass
  attr_reader :dynamic
  attr_reader :immediate
  
  def initialize(target, range, pass, dynamic, immediate)
    if target.is_a?(Game_Character)
      @char = target
    else
      @x, @y = target
    end
    @range = range
    @pass = pass
    @dynamic = dynamic
    @immediate = immediate
  end
  
  def x
    return (@char != nil ? @char.x : @x)
  end
  
  def y
    return (@char != nil ? @char.y : @y)
  end
  
end

#==============================================================================
# PathRequest
#==============================================================================

class PathRequest
  
  attr_reader :open
  attr_reader :closed
  attr_reader :sx
  attr_reader :sy
  attr_reader :target
  
  def initialize(sx, sy, target)
    @sx, @sy, @target = sx, sy, target
    @open = {[@sx, @sy, 0] => -1}
    @closed = Table.new($game_map.width, $game_map.height)
  end
  
  def backtrack(tx, ty)
    cx, cy, x, y, result = tx, ty, 0, 0, []
    loop do
      cx, cy = cx - x, cy - y
      break if cx == @sx && cy == @sy
      result.unshift(@closed[cx, cy])
      x, y = PathFinder::DIR_OFFSETS[@closed[cx, cy]]
    end
    return self.modify_8_way(result)
  end
  
  def modify_8_way(result)
    if BlizzCFG::DIRECTIONS_8_WAY
      result.each_index {|i|
          if result[i] != nil && result[i + 1] != nil
            case [result[i], result[i + 1]]
            when PathFinder::DIR_DOWN_LEFT, PathFinder::DIR_LEFT_DOWN
              result[i], result[i + 1] = 5, nil
            when PathFinder::DIR_DOWN_RIGHT, PathFinder::DIR_RIGHT_DOWN
              result[i], result[i + 1] = 6, nil
            when PathFinder::DIR_LEFT_UP, PathFinder::DIR_UP_LEFT
              result[i], result[i + 1] = 7, nil
            when PathFinder::DIR_RIGHT_UP, PathFinder::DIR_UP_RIGHT
              result[i], result[i + 1] = 8, nil
            end
          end}
      result.compact!
    end
    return result
  end
  
end

#==============================================================================
# Game_System
#==============================================================================

class Game_System
  
  alias update_lagless_path_finder_later update
  def update
    PathFinder.update
    update_lagless_path_finder_later
  end
  
end

#==============================================================================
# Game_Map
#==============================================================================

class Game_Map
  
  alias setup_lagless_path_finder_later setup
  def setup(map_id)
    PathFinder.clear
    setup_lagless_path_finder_later(map_id)
  end
  
end

#==============================================================================
# Game_Character
#==============================================================================

class Game_Character
  
  def add_path_target(target)
    @path_targets = [] if @path_targets == nil
    @path_targets.push(target)
  end
  
  def clear_path_target
    @path_targets = nil
  end
  
  def next_path_target
    if @path_targets.size <= 1
      self.clear_path_target
    else
      @path_targets.shift
    end
  end
  
  def has_path_target?
    return (@path_targets != nil && @path_targets.size > 0)
  end
  
  def set_found_path(path)
    return if path.size == 0
    route = RPG::MoveRoute.new
    route.repeat = false
    path.reverse.each {|dir| route.list.unshift(RPG::MoveCommand.new(dir))}
    self.force_move_route(route)
  end
  
  def set_found_step(path)
    return if path.size == 0
    route = RPG::MoveRoute.new
    route.repeat = false
    route.list.unshift(RPG::MoveCommand.new(path[0]))
    self.force_move_route(route)
  end
  
  alias update_lagless_path_finder_later update
  def update
    update_lagless_path_finder_later
    return if self.moving? || !self.has_path_target? || self.jumping?
    if (@x - @path_targets[0].x).abs + (@y - @path_targets[0].y).abs <=
        @path_targets[0].range
      self.next_path_target
      check = true
    else
      check = @path_targets[0].dynamic
    end
    if check && self.has_path_target?
      if @path_targets[0].immediate
        PathFinder._find(self, @path_targets[0])
      else
        PathFinder._request(self, @path_targets[0])
      end
    end
  end
  
end
