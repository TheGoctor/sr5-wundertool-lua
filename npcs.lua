--------------------------------------------------------------------------------
-- Character definitions for various critters and Prime Runners.
-- @author Mac Reichelt
-- @copyright Copyright (c) 2015 Mac Reichelt
--------------------------------------------------------------------------------

require "character"

-- Critters
GabrielHounds = {
    name = "GabrielHound",
    bod = 3,
    agi = 5,
    rea = 6,
    str = 7,
    wil = 4,
    log = 2,
    int = 3,
    cha = 2,
    edg = 2,
    ess = 6,
    mag = 5,
    skills = {
        perception = { pool = 7 },
        running = { pool = 8 },
        sneaking = { pool = 10 },
        tracking = { pool = 8 },
        unarmed = { pool = 12 },
    },
    weapon = {
        claws = { skill = "unarmed", dmg = 8, ap = 1 },
    },
    movement = "10/30/+4",
    armor_rating = 0,
    init_dice = 2,
};

LordsOfChaosRecruit = {
    name = "LordsOfChaosRecruit",
    bod = 3,
    agi = 4,
    rea = 3,
    str = 3,
    wil = 2,
    log = 2,
    int = 3,
    cha = 2,
    edg = 0,
    ess = 5.8,
    mag = 0,
    skills = {
        blades = { pool = 5, },
        clubs = { pool = 5, },
        unarmed = { pool = 5, },
        ettiquette = { pool = 3, spec = "gangs" },
        intimidation = { pool = 4 },
        pistols = { pool = 5 },
    },
    weapon = {
        hand_razor = { skill = "blades", dmg = 4, ap = 3 },
        browning_ultra_power = { skill = "pistols", acc = 6, dmg = 8, ap = 1, mode = "sa", rc = 0, ammo = 10, ammo_type = "Clip" },
        knife = { skill = "blades", acc = 5, reach = 0, dmg = 4, ap = 1 },
    },
    movement = "",
    armor_rating = 4,
    init_dice = 1,
};

EagleOwl = {
    name = "EagleOwl",
    bod = 3,
    agi = 6,
    rea = 5,
    str = 3,
    wil = 4,
    log = 4,
    int = 6,
    cha = 4,
    edg = 3,
    ess = 6,
    mag = 0,
    skills = {
        flight = { pool = 4 },
        perception = { pool = 4 },
        tracking = { pool = 3 },
        unarmed = { pool = 3 },
    },
    weapon = {
        claws = { skill = "unarmed", dmg = 3, ap = 0 },
    },
    movement = "",
    armor_rating = 0,
    init_dice = 1,
};

Dog = {
    name = "Dog",
    bod = 4,
    agi = 3,
    rea = 4,
    str = 4,
    wil = 3,
    log = 2,
    int = 4,
    cha = 3,
    edg = 4,
    ess = 6,
    mag = 0,
    skills = {
        intimidation = { pool = 4 },
        perception = { pool = 5, spec = "smell", },
        running = { pool = 5 },
        tracking = { pool = 6 },
        unarmed = { pool = 5 },
    },
    weapon = {
        bite = { skill = "unarmed", dmg = 5, ap = 0 },
    },
    movement = "6/24/+4",
    armor_rating = 0,
    init_dice = 1,
};

HellHound = {
    name = "HellHound",
    bod = 6,
    agi = 4,
    rea = 5,
    str = 6,
    wil = 4,
    log = 2,
    int = 4,
    cha = 3,
    edg = 3,
    ess = 6,
    mag = 5,
    skills = {
        exotic_ranged = { pool = 4 },
        intimidation = { pool = 3 },
        perception = { pool = 3 },
        running = { pool = 4 },
        sneaking = { pool = 5 },
        tracking = { pool = 5 },
        unarmed = { pool = 3 },
    },
    weapon = {
        bite = { skill = "unarmed", dmg = 7, ap = 1, elem = "fire" },
    },
    movement = "8/24/+4",
    armor_rating = 2,
    init_dice = 3,
};

Barghest = {
    name = "Barghest",
    bod = 8,
    agi = 5,
    rea = 6,
    str = 6,
    wil = 4,
    log = 2,
    int = 5,
    cha = 5,
    edg = 4,
    ess = 6,
    mag = 5,
    skills = {
        intimidation = { pool = 7 },
        perception = { pool = 6 },
        running = { pool = 5 },
        tracking = { pool = 6 },
        unarmed = { pool = 8 },
    },
    weapon = {
        bite = { skill = "unarmed", dmg = 8, ap = 1 },
    },
    movement = "10/30/+4",
    armor_rating = 3,
    init_dice = 2,
};

Piasma = {
    name = "Piasma",
    bod = 12,
    agi = 5,
    rea = 5,
    str = 12,
    wil = 4,
    log = 2,
    int = 4,
    cha = 1,
    edg = 2,
    ess = 6,
    mag = 0,
    skills = {
        intimidation = { pool = 4 },
        perception = { pool = 5 },
        sneaking = { pool = 10 },
        tracking = { pool = 5 },
        unarmed = { pool = 7 },
    },
    weapon = {
        bite = { skill = "unarmed", dmg = 13, ap = 2 },
        claws = { skill = "unarmed", dmg = 13, ap = 2 },
    },
    movement = "10/35/+4",
    armor_rating = 5,
    init_dice = 1,
};

NeoTribalScout = {
    name = "NeoTribalScout",
    bod = 4,
    agi = 4,
    rea = 4,
    str = 3,
    wil = 3,
    log = 3,
    int = 4,
    cha = 3,
    edg = 0,
    ess = 6,
    mag = 0,
    skills = {
        blades = { pool = 7 },
        clubs = { pool = 7 },
        unarmed = { pool = 7 },
        perception = { pool = 7 },
        pistols = { pool = 7 },
        tracking = { pool = 7 },
        thrown = { pool = 7 },
    },
    weapon = {
        colt_america_l36 = { skill = "pistols", acc = 7, dmg = 7, ap = 0, mode = "sa", rc = 0, ammo = 11, ammo_type = "Clip", },
        molotov = { skill = "thrown", acc = 2, dmg = 7, ap = 0, elem = "fire" },
        thermal_smoke_grenade = { skill = "thrown", },
    },
    movement = "8/16/+2",
    armor_rating = 9,
    init_dice = 1,
};

NeoTribalWarrior = {
    name = "NeoTribalWarrior",
    bod = 3,
    agi = 5,
    rea = 4,
    str = 3,
    wil = 4,
    log = 3,
    int = 4,
    cha = 3,
    edg = 0,
    ess = 6,
    mag = 0,
    skills = {
        blades = { pool = 5 },
        auto = { pool = 6 },
        longarms = { pool = 6 },
        pistols = { pool = 6 },
        gymnastics = { pool = 4 },
        intimidation = { pool = 4 },
        unarmed = { pool = 5 },
    },
    weapon = {
        ak97 = { skill = "auto", acc = 5, dmg = 10, ap = 0, mode = "sa/bf/fa", rc = 0, ammo = 38, ammo_type = "Clip" },
        spear = { skill = "blades", acc = 3, dmg = 5, ap = 0 },
    },
    movement = "10/20/+2",
    armor_rating = 9,
    init_dice = 1,
};

Shedim = {
    name = "Shedim",
    bod = 6,
    agi = 6,
    rea = 8,
    str = 6,
    wil = 6,
    log = 6,
    int = 6,
    cha = 6,
    edg = 6,
    ess = 6,
    mag = 6,
    force = 6,
    skills = {
        assensing = { pool = 12 },
        astral_combat = { pool = 12 },
        gymnastics = { pool = 14 },
        perception = { pool = 12 },
        unarmed = { pool = 12 },
    },
    weapon = {
        unarmed = { skill = "unarmed" },
    },
    powers = {
        "Astral Form",
        "Deathly Aura",
        "Energy Drain (Karma, Touch Range, Physical Damage)",
        "Fear",
        "Immunity (Age, Pathogens, Toxins)",
        "Paralyzing Touch",
        "Sapience",
        "Shadow Cloak",
    },
    movement = "12/24/+2",
    armor_rating = 0,
    init_dice = 2,
};

-- Prime runners
Donnie = Character{
    name = "Donnie Hua",
    bod = 3,
    agi = 3,
    rea = 3,
    str = 2,
    wil = 4,
    log = 5,
    int = 3,
    cha = 4,
    edg = 1,
    ess = 5,
    mag = 4,
    skills = {
        pistols = { pool = 7 },
        counterspelling = { pool = 8 },
        ritual = { pool = 8 },
        spellcasting = { pool = 8 },
        assensing = { pool = 8 },
    },
    weapon = {
        colt_govt_2066 = { skill = "pistols", acc = 6, dmg = 7, ap = 1, rc = 0, ammo = 14, ammo_type = "Clip" },
    },
    spells = {
        Stunbolt = {},
        Detox = {},
        Analyze = {},
        Truth = {},
        Catalog = {},
        Heal = {},
    },
    movement = "6/12/+2",
    armor_rating = 6,
    init_dice = 1,
};

Arona = Character{
    name = "Arona",
    bod = 7,
    agi = 4,
    rea = 5,
    str = 6,
    wil = 3,
    log = 3,
    int = 3,
    cha = 4,
    edg = 2,
    ess = 3.5,
    mag = 0,
    skills = {
        blades = { pool = 8 },
        unarmed = { pool = 8 },
        clubs = { pool = 8 },
        etiquette = { pool = 8 },
        intimidation = { pool = 9 },
        heavy = { pool = 8, spec = "mg" },
        gunnery = { pool = 8 },
        pilot_ground = { pool = 6 },
    },
    weapon = {
        ingram_valiant = { skill = "heavy", acc = 6, dmg = 9, ap = 2, mode = "bf/fa", rc = 3, ammo = 50, ammo_type = "Clip" },
        knife = { skill = "blade", reach = 0, acc = 5, dmg = 7, ap = 1 },
    },
    movement = "8/16/+1",
    armor_rating = 14,
    init_dice = 3,
};

Bhagat = Character{
    name = "Bhagat Singh",
    bod = 8,
    agi = 4,
    rea = 5,
    str = 6,
    wil = 4,
    log = 3,
    int = 3,
    cha = 4,
    edg = 2,
    ess = 6,
    mag = 5,
    skills = {
        blades = { pool = 11 },
        etiquette = { pool = 7 },
        gymnastics = { pool = 7 },
        perception = { pool = 6 },
        auto = { pool = 6 },
        pistols = { pool = 7 },
    },
    weapon = {
        curved_sword = { skill = "blades", reach=1, acc = 6, dmg = 11, ap = 2 },
    },
    movement = "8/16/+1",
    armor_rating = 13,
    init_dice = 3,
};

Chaaya = Character{
    name = "Chaaya",
    bod = 2,
    agi = 4,
    rea = 4,
    str = 3,
    wil = 5,
    log = 2,
    int = 4,
    cha = 2,
    edg = 1,
    ess = 6,
    mag = 5,
    skills = {
        blades = { pool = 7 },
        perception = { pool = 9 },
        sneaking = { pool = 9 },
        survival = { pool = 12 },
        tracking = { pool = 9 },
        unarmed = { pool = 9 },
    },
    weapon = {
        knife = { skill = "blade", acc = 5, dmg = 4, ap = 1 },
    },
    movement = "8/16/+2",
    armor_rating = 6,
    init_dice = 1,
};

Darrick = Character{
    name = "Darrick",
    bod = 3,
    agi = 3,
    rea = 4,
    str = 3,
    wil = 5,
    log = 4,
    int = 5,
    cha = 4,
    edg = 3,
    ess = 6,
    mag = 4,
    skills = {
        astral_combat = { pool = 9 },
        banishing = { pool = 8 },
        counterspelling = { pool = 8 },
        perception = { pool = 9 },
        pistols = { pool = 5 },
        sneaking = { pool = 7 },
        spellcasting = { pool = 9 },
        survival = { pool = 9 },
        tracking = { pool = 8 },
        unarmed = { pool = 4 },
    },
    weapon = {
        streetline_special = { skill = "pistols", acc = 4, dmg = 7, ap = 0, mode = "sa", rc = 0, ammo = 6, ammo_type = "Clip" },
    },
    movement = "10/20/+2",
    armor_rating = 6,
    init_dice = 1,
};

Daughter = Character{
    name = "Daughter",
    bod = 6,
    agi = 2,
    rea = 3,
    str = 5,
    wil = 5,
    log = 3,
    int = 3,
    cha = 5,
    edg = 3,
    ess = 6,
    mag = 5,
    skills = {
        assensing = { pool = 6 },
        astral_combat = { pool = 9 },
        banishing = { pool = 9 },
        binding = { pool = 9 },
        summoning = { pool = 9 },
        intimidation = { pool = 9 },
        perception = { pool = 7 },
        counterspelling = { pool = 10 },
        ritual = { pool = 10 },
        spellcasting = { pool = 10 },
        sneaking = { pool = 5 },
        unarmed = { pool = 7 },
    },
    weapon = {
      bite = { skill = "unarmed", dmg = 6, ap = 0},
    },
    spells = {
        silence,
        improved_invisibility,
        control_emotion,
        magic_fingers,
        shadow,
        stunball,
        mind_probe,
    },
    movement = "10/20/+2",
    armor_rating = 12,
    init_dice = 1,
};

Doctor = Character{
    name = "Dr. Auslander",
    bod = 8,
    agi = 8,
    rea = 11,
    str = 8,
    wil = 8,
    log = 8,
    int = 8,
    cha = 8,
    edg = 8,
    ess = 8,
    mag = 8,
    force = 8,
    skills = {
        assensing = { pool = 16 },
        astral_combat = { pool = 16 },
        counterspelling = { pool = 16 },
        gymnastics = { pool = 18 },
        perception = { pool = 16 },
        spellcasting = { pool = 16 },
        unarmed = { pool = 16 },
    },
    weapon = {
        unarmed = { skill = "unarmed" },
    },
    powers = {
        "Astral Form",
        "Masking (Initiate Power)",
        "Banishing Resistance",
        "Deathly Aura",
        "Energy Drain (Karma, Touch Range, Physical Damage)",
        "Fear",
        "Immunity (Age, Pathogens, Toxins)",
        "Paralyzing Touch",
        "Regeneration",
        "Sapience",
        "Shadow Cloak",
        "Accident",
        "Noxious Breath",
    },
    spells = {
        armor = { type = "P", drain = -2, range = "LOS", duration = "S", page = 292 },
        ball_lightning = { direct = false, elemental = "electric", type = "P", drain = -1, range = "LOS (A)", dmg = "P", duration = "I", page = 284 },
        death_touch = { direct = true, type = "M", drain = -6, range = "T", dmg = "P", duration = "I", page = 284 },
        detect_life = { type = "M", drain = -3, range = "T", duration = "S", page = 286 },
        levitate = { type = "P", drain = -2, range = "LOS", duration = "S", page = 293 },
        powerbolt = { direct = true, type = "P", drain = -3, range = "LOS", dmg = "P", duration = "I", page = 284 },
        poltergeist = { type = "P", drain = -2, range = "LOS (A)", duration = "S", page = 294 },
        toxic_wave = { direct = false, elemental = "acid", type = "P", drain = -1, range = "LOS (A)", dmg = "P", duration = "I", page = 283 },
    },
    movement = "12/24/+2",
    armor_rating = 0,
    init_dice = 2,
};

Spazz = Character{
    name = "John 'Spazz' Silva",
    bod = 10,
    agi = 9,
    rea = 7,
    str = 7,
    wil = 5,
    log = 7,
    int = 5,
    cha = 5,
    edg = 5,
    ess = 0.745,
    skills = {
        auto =      { pool = 17, specialization = "Machine Pistols" }, -- already added +2 for spec
        gymnastics = { pool = 11 },
        instruction = { pool = 8 },
        longarms = { pool = 12 },
        perception = { pool = 8 },
        pilot_ground = { pool = 10 },
        pistols = { pool = 12 },
        unarmed = { pool = 14 },
    },
    weapon = {
        unarmed = { skill = "unarmed" },
        steyr_tmp = { skill = "auto", acc = 4, dmg = 7, ap = 0, rc = 0 },
    },
    movement = "18/36/+2",
    armor_rating = 8,
    init_dice = 3,
};
