def carol_copy_stats()
  eid = 86; #Carol enemy
  aid = 2; #Carol actor
  copy_stats(eid, aid)
end

def athena_copy_stats()
  eid = 91; #Athena enemy
  aid = 6; #Athena actor
  copy_stats(eid, aid)
end

def evelyn_copy_stats()
  eid = 116; #Evelyn enemy
  aid = 7; #Evelyn actor
  copy_stats(eid, aid)
end

def copy_stats(eid, aid)
  #Copy stats from actor to enemy. 
  #If fired on turn 0, make sure to copy hp from maxhp separately using game_troop.
  actor = $game_actors[aid];
  $data_enemies[eid].maxhp = actor.maxhp;
  $data_enemies[eid].str = actor.str;
  $data_enemies[eid].dex = actor.dex;
  $data_enemies[eid].agi = actor.agi;
  $data_enemies[eid].int = actor.int;
  $data_enemies[eid].atk = actor.atk;
  $data_enemies[eid].pdef = actor.pdef;
  $data_enemies[eid].mdef = actor.mdef;
  $data_enemies[eid].eva = actor.eva;
end

def carol_fight()
  suki = $game_party.actors[0]
  carol = $game_troop.enemies[0]
  $game_variables[148] = 0
  
  if suki.state?(19) #weakened
    $game_variables[148] = 10  #subdue
    return
  end
  
  if carol.sp >= 40
    $game_variables[148] = 1  #quick claws
    return
  end
end

def athena_fight()
  suki = $game_party.actors[0]
  athena = $game_troop.enemies[0]
  $game_variables[148] = 0
  
  if suki.state?(2) #stunned
    $game_variables[148] = 10  #subdue
    $game_variables[714] = 1 #tied while stunned
    return
  end
  
  #if suki.hp.to_f/suki.maxhp < 0.15
  if suki.state?(19) #weakened
    $game_variables[148] = 10  #subdue
    return
  end
  
  if suki.armor4_id != 36 #amulet of focus
    if athena.sp >= 60
      $game_variables[148] = 1  #leg sweep
      return
    end
  end
  
  if athena.sp >= 45
    $game_variables[148] = 2  #chest punch
    return
  end
end

def evelyn_fight()
  suki = $game_party.actors[0]
  evelyn = $game_troop.enemies[0]
  $game_variables[148] = 0
  
  #if suki.hp.to_f/suki.maxhp < 0.15
  if suki.state?(19) #weakened
    $game_variables[148] = 10  #subdue
    return
  end
  
  if suki.armor3_id == 111  #princess dress
    princess = true
  else
    princess = false
  end
  
  if suki.armor4_id == 29   #ring of fire
    rof = true
  else
    rof = false
  end
  
  if evelyn.hp.to_f/evelyn.maxhp <= 0.15
    if evelyn.sp >= 40
      $game_variables[148] = 3  #greater heal
      return
    end
    if evelyn.sp >= 20
      $game_variables[148] = 2  #heal
      return
    end
  end
  
  #if evelyn.sp >= 30 and !suki.state?(44)
  #  $game_variables[148] = 7  #rally
  #  return
  #end
      
  #if evelyn.hp.to_f/evelyn.maxhp <= 0.6 and evelyn.sp >= 40 and suki.sp >= 35
  #  $game_variables[148] = 3  #greater heal
  #  return
  #end
  
  if !princess  #if princess dress only absorb when close to chest punch cost, otherwise not worth it
    if !suki.state?(11)
      if suki.sp >= 35  #and suki.sp < 45
        $game_variables[148] = 1  #absorb sp
        return
      end
    else
      if suki.sp >= 45
        $game_variables[148] = 1  #absorb sp
        return
      end
    end
  else
    if !suki.state?(11)
      if suki.sp >= 35  and suki.sp < 55
        $game_variables[148] = 1  #absorb sp
        return
      end
    else
      if suki.sp >= 45 and suki.sp < 65
        $game_variables[148] = 1  #absorb sp
        return
      end
    end
  end
  
  if evelyn.hp.to_f/evelyn.maxhp <= 0.5 and evelyn.sp >= 40
    $game_variables[148] = 3  #greater heal
    return
  end
  
  if evelyn.sp >= 20 and !suki.state?(9)
    $game_variables[148] = 5  #earth
    return
  end
  
  if evelyn.sp >= 20 and !suki.state?(11)
    $game_variables[148] = 6  #ice
    return
  end
  
  if evelyn.sp >= 25 and !rof
    $game_variables[148] = 4  #fire
    return
  end
  
  if evelyn.sp >= 20
    tmp = rand(2)
    if tmp == 0
      $game_variables[148] = 5  #earth
      return
    end
    if tmp == 1
      $game_variables[148] = 6  #earth
      return
    end
  end
    
  if suki.sp > 5
    $game_variables[148] = 1  #absorb sp
    return
  end
  
  $game_variables[148] = 9 #defend
  return
end