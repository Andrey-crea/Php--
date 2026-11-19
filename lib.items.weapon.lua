-- Recovered code lib.items.weapon.lu + fix after decompilation
-- Lua 5.1.5
-- Day R Survival v694
local item_list = {
    -- Дубина с гвоздями
    {
        id = 'nail_club',
        tagList = {
            'weapon',
            'equipment_related',
            'durability',
            'steel_arms',
            'decay_1y'
        },
        singleDepreciation = true,
        level = {'weapon', 1},
        weight = 1500,
        events = {usedInBattle = {depreciation = 4, isPerkEffect = true}}
    },
    -- Арбалет
    {
        id = 'crossbow',
        template = 'crossbow',
        addTags = {'light_weapon'},
        level = {'weapon', 5},
        ammo = {'crossbow_ammo', 1},
        weight = 2100,
        events = {
            craft = {
                access = {needPerk = {{'poisoner'}}},
                name = strings.events.switch,
                spendTime = 1,
                need = {{'crossbow', 1, true}},
                give = {{'crossbow_p', 1}}
            },
            repair = {need = {{'glue', 1, true}}},
            usedInBattle = {depreciation = 6.666666666666667}
        }
    },
    -- Арбалет (отравленные болты)
    {
        id = 'crossbow_p',
        template = 'crossbow',
        addTags = {'light_weapon'},
        imageFile = 'crossbow',
        comboImageFile = 'combo/poison',
        comboImageSize = 0.25,
        comboImageX = 0.28,
        comboImageY = -0.28,
        level = {'weapon', 5},
        ammo = {'crossbow_p_ammo', 1},
        weight = 2100,
        events = {
            craft = {
                spendTime = 1,
                name = strings.events.switch,
                need = {{'crossbow_p', 1, true}},
                give = {{'crossbow', 1}}
            },
            repair = {need = {{'glue', 1, true}}},
            usedInBattle = {
                needPerk = {{'poisoner'}},
                depreciation = 6.666666666666667
            }
        }
    },
    -- Арбалет 2
    {
        id = 'crossbow2',
        template = 'crossbow',
        addTags = {'light_weapon'},
        level = {'weapon', 18},
        ammo = {'crossbow_ammo', 1},
        weight = 2800,
        events = {
            craft = {
                access = {needPerk = {{'poisoner'}}},
                spendTime = 1,
                name = strings.events.switch,
                need = {{'crossbow2', 1, true}},
                give = {{'crossbow2_p', 1}}
            },
            repair = {need = {{'glue', 3, true}}},
            usedInBattle = {depreciation = 5}
        }
    },
    -- Арбалет 2 (отравленные болты)
    {
        id = 'crossbow2_p',
        template = 'crossbow',
        addTags = {'light_weapon'},
        imageFile = 'crossbow2',
        comboImageFile = 'combo/poison',
        comboImageSize = 0.25,
        comboImageX = 0.28,
        comboImageY = -0.28,
        level = {'weapon', 18},
        ammo = {'crossbow_p_ammo', 1},
        weight = 2800,
        events = {
            craft = {
                spendTime = 1,
                name = strings.events.switch,
                need = {{'crossbow2_p', 1, true}},
                give = {{'crossbow2', 1}}
            },
            repair = {need = {{'glue', 3, true}}},
            usedInBattle = {needPerk = {{'poisoner'}}, depreciation = 5}
        }
    },
    -- Арбалет 3
    {
        id = 'crossbow3',
        template = 'crossbow',
        addTags = {'light_weapon'},
        level = {'weapon', 53},
        ammo = {'crossbow_ammo', 1},
        weight = 4500,
        events = {
            craft = {
                access = {needPerk = {{'poisoner'}}},
                spendTime = 1,
                name = strings.events.switch,
                need = {{'crossbow3', 1, true}},
                give = {{'crossbow3_p', 1}}
            },
            repair = {
                need = {
                    {'glue', 5, true},
                    {'scrap_metal', 5, true},
                    {'welder', 1},
                    {'generator_fuel', 1},
                    {'tools_tag', 1}
                }
            },
            usedInBattle = {depreciation = 2}
        }
    },
    -- Арбалет 3 (отравленные болты)
    {
        id = 'crossbow3_p',
        template = 'crossbow',
        addTags = {'light_weapon'},
        imageFile = 'crossbow3',
        comboImageFile = 'combo/poison',
        comboImageSize = 0.25,
        comboImageX = 0.28,
        comboImageY = -0.28,
        level = {'weapon', 53},
        ammo = {'crossbow_p_ammo', 1},
        weight = 4500,
        events = {
            craft = {
                spendTime = 1,
                name = strings.events.switch,
                need = {{'crossbow3_p', 1, true}},
                give = {{'crossbow3', 1}}
            },
            repair = {
                need = {
                    {'glue', 5, true},
                    {'scrap_metal', 5, true},
                    {'welder', 1},
                    {'generator_fuel', 1},
                    {'tools_tag', 1}
                }
            },
            usedInBattle = {needPerk = {{'poisoner'}}, depreciation = 2}
        }
    },
    -- Пистолет Макарова
    {
        id = 'pm',
        template = 'pistol',
        isTagIcon = true,
        addTags = {'light_weapon', 'decay_1y'},
        level = {'weapon', 6},
        ammo = {'pm_ammo', 1},
        weight = 730,
        events = {
            repair = {need = {{'pistol_parts', 1, true}, {'oil', 10, true}}},
            craft = {
                access = {needPerk = {{'dual_wield'}}},
                spendTime = 60,
                need = {{'pm', 2, true}},
                give = {{'pm_dual', 1}}
            },
            craft2 = {
                name = strings.events.disassemble,
                count = 4,
                spendTime = 30,
                isConfirm = true,
                sound = 'craft',
                need = {{'pm', 1, true}},
                give = {{'pistol_parts', 2}}
            },
            usedInBattle = {depreciation = 2, give = {{'pm_shell', {0, 1}}}},
            broke = {give = {{'pm_broken', 1, 0}}}
        }
    },
    -- Два ПМ
    {
        id = 'pm_dual',
        template = 'pistol',
        addTags = {'light_weapon', 'decay_1y', 'not_package'},
        level = {'weapon', 6},
        ammo = {'pm_ammo', 2},
        weight = 1460,
        events = {
            repair = {need = {{'pistol_parts', 2, true}, {'oil', 20, true}}},
            usedInBattle = {
                needPerk = {{'dual_wield'}},
                depreciation = 1.6666666666666667,
                give = {{'pm_shell', {0, 2}}}
            },
            broke = {give = {{'pm_broken', 2, 0}}}
        }
    },
    -- Сломанный ПМ
    {
        id = 'pm_broken',
        template = 'weapon_broken',
        addTags = {'decay_1y'},
        weight = 730,
        imageFile = 'pm',
        events = {
            craft = {
                need = {{'pm_broken', 1, true}},
                give = {{'pistol_parts', 1}}
            }
        }
    },
    -- Пистолет ТТ
    {
        id = 'tt',
        template = 'pistol',
        addTags = {'light_weapon'},
        level = {'weapon', 30},
        ammo = {'tt_ammo', 1},
        weight = 900,
        events = {
            repair = {need = {{'pistol_parts', 1, true}, {'oil', 15, true}}},
            craft = {
                access = {needPerk = {{'dual_wield'}}},
                spendTime = 60,
                need = {{'tt', 2, true}},
                give = {{'tt_dual', 1}}
            },
            craft2 = {
                name = strings.events.disassemble,
                count = 4,
                spendTime = 30,
                isConfirm = true,
                sound = 'craft',
                need = {{'tt', 1, true}},
                give = {{'pistol_parts', 2}}
            },
            usedInBattle = {
                depreciation = 1.6666666666666667,
                give = {{'tt_shell', {0, 1}}}
            },
            broke = {give = {{'tt_broken', 1, 0}}}
        }
    },
    -- Два ТТ
    {
        id = 'tt_dual',
        template = 'pistol',
        addTags = {'light_weapon', 'not_package'},
        level = {'weapon', 30},
        ammo = {'tt_ammo', 2},
        weight = 1800,
        events = {
            repair = {need = {{'pistol_parts', 2, true}, {'oil', 30, true}}},
            usedInBattle = {
                needPerk = {{'dual_wield'}},
                depreciation = 1.5384615384615385,
                give = {{'tt_shell', {0, 2}}}
            },
            broke = {give = {{'tt_broken', 2, 0}}}
        }
    },
    -- Сломанный ТТ
    {
        id = 'tt_broken',
        template = 'weapon_broken',
        weight = 900,
        imageFile = 'tt',
        events = {
            craft = {
                need = {{'tt_broken', 1, true}},
                give = {{'pistol_parts', 1}}
            }
        }
    },
    -- Пистолет Стечкина (АПС)
    {
        id = 'aps',
        template = 'pistol',
        addTags = {'light_weapon'},
        level = {'weapon', 53},
        ammo = {'pm_ammo', 3},
        weight = 1000,
        events = {
            repair = {need = {{'pistol_parts', 1, true}, {'oil', 15, true}}},
            craft = {
                access = {needPerk = {{'dual_wield'}}},
                spendTime = 60,
                need = {{'aps', 2, true}},
                give = {{'aps_dual', 1}}
            },
            craft2 = {
                name = strings.events.disassemble,
                count = 4,
                spendTime = 30,
                isConfirm = true,
                sound = 'craft',
                need = {{'aps', 1, true}},
                give = {{'pistol_parts', 2}}
            },
            usedInBattle = {
                depreciation = 1.6666666666666667,
                give = {{'pm_shell', {0, 3}}}
            },
            broke = {give = {{'aps_broken', 1, 0}}}
        }
    },
    -- Два АПС
    {
        id = 'aps_dual',
        template = 'pistol',
        addTags = {'light_weapon', 'not_package'},
        level = {'weapon', 53},
        ammo = {'pm_ammo', 6},
        weight = 2000,
        events = {
            repair = {need = {{'pistol_parts', 2, true}, {'oil', 30, true}}},
            usedInBattle = {
                needPerk = {{'dual_wield'}},
                depreciation = 1.4285714285714286,
                give = {{'pm_shell', {0, 6}}}
            },
            broke = {give = {{'aps_broken', 2, 0}}}
        }
    },
    -- Сломанный АПС
    {
        id = 'aps_broken',
        template = 'weapon_broken',
        weight = 1000,
        imageFile = 'aps',
        events = {
            craft = {
                need = {{'aps_broken', 1, true}},
                give = {{'pistol_parts', 1}}
            }
        }
    },
    -- Револьвер Наган
    {
        id = 'nagant',
        template = 'pistol',
        addTags = {'light_weapon'},
        level = {'weapon', 22},
        ammo = {'nagant_ammo', 1},
        weight = 880,
        events = {
            repair = {need = {{'nagant_parts', 1, true}, {'oil', 10, true}}},
            craft = {
                access = {needPerk = {{'dual_wield'}}},
                spendTime = 60,
                need = {{'nagant', 2, true}},
                give = {{'nagant_dual', 1}}
            },
            craft2 = {
                name = strings.events.disassemble,
                count = 4,
                spendTime = 30,
                isConfirm = true,
                sound = 'craft',
                need = {{'nagant', 1, true}},
                give = {{'nagant_parts', 2}}
            },
            usedInBattle = {
                depreciation = 1,
                give = {{'nagant_shell', {0, 1}}}
            },
            broke = {give = {{'nagant_broken', 1}}}
        }
    },
    -- Два нагана
    {
        id = 'nagant_dual',
        template = 'pistol',
        addTags = {'light_weapon', 'not_package'},
        level = {'weapon', 22},
        ammo = {'nagant_ammo', 2},
        weight = 1760,
        events = {
            repair = {need = {{'nagant_parts', 2, true}, {'oil', 20, true}}},
            usedInBattle = {
                needPerk = {{'dual_wield'}},
                depreciation = 1,
                give = {{'nagant_shell', {0, 2}}}
            },
            broke = {give = {{'nagant_broken', 2}}}
        }
    },
    -- Сломанный наган
    {
        id = 'nagant_broken',
        template = 'weapon_broken',
        weight = 880,
        imageFile = 'nagant',
        events = {
            craft = {
                need = {{'nagant_broken', 1, true}},
                give = {{'nagant_parts', 1}}
            }
        }
    },
    -- Маузер
    {
        id = 'mauser',
        template = 'pistol',
        addTags = {'important_tag', 'light_weapon'},
        ammo = {'tt_ammo', 3},
        weight = 1250,
        events = {
            repair = {need = {{'pistol_parts', 1, true}, {'oil', 15, true}}},
            craft = {
                access = {needPerk = {{'dual_wield'}}},
                spendTime = 60,
                need = {{'mauser', 2, true}},
                give = {{'mauser_dual', 1}}
            },
            usedInBattle = {depreciation = 2, give = {{'tt_shell', {0, 3}}}},
            broke = {give = {{'mauser_broken', 1, 0}}}
        }
    },
    -- Два маузера
    {
        id = 'mauser_dual',
        template = 'pistol',
        addTags = {'important_tag', 'light_weapon', 'not_package'},
        ammo = {'tt_ammo', 6},
        weight = 2500,
        events = {
            repair = {need = {{'pistol_parts', 2, true}, {'oil', 30, true}}},
            usedInBattle = {
                needPerk = {{'dual_wield'}},
                depreciation = 2,
                give = {{'tt_shell', {0, 6}}}
            },
            broke = {give = {{'mauser_broken', 2, 0}}}
        }
    },
    -- Сломанный маузер
    {
        id = 'mauser_broken',
        template = 'weapon_broken',
        addTags = {'important_tag'},
        weight = 1250,
        imageFile = 'mauser',
        events = {
            craft = {
                name = strings.events.repair,
                need = {
                    {'mauser_broken', 1, true},
                    {'pistol_parts', 10, true},
                    {'oil', 100, true},
                    {'tools_tag', 1}
                },
                give = {{'mauser', 1}}
            }
        }
    },
    -- Самопал
    {
        id = 'homemade_gun',
        template = 'pistol',
        addTags = {'light_weapon', 'decay_1y'},
        level = {'weapon', 14},
        ammo = {'homemade_gun_ammo', 1},
        weight = 1400,
        events = {
            repair = {
                need = {{'glue', 2, true}, {'water_pipe', 1, true}},
                depreciation = -100
            },
            usedInBattle = {depreciation = 10}
        }
    },
    -- Самодельное ружьё
    {
        id = 'homemade_rifle',
        template = 'rifle',
        addTags = {'decay_1y', 'heavy_weapon'},
        level = {'weapon', 38},
        ammo = {'homemade_rifle_ammo', 1},
        weight = 2200,
        events = {
            repair = {
                need = {
                    {'glue', 5, true},
                    {'scrap_metal', 1, true},
                    {'tools_tag', 1}
                }
            },
            usedInBattle = {depreciation = 5}
        }
    },
    -- Ружьё ИЖ
    {
        id = 'izh',
        template = 'shotgun',
        addTags = {'heavy_weapon'},
        level = {'weapon', 26},
        ammo = {'shotgun_ammo', 1},
        weight = 2800,
        events = {
            repair = {need = {{'shotgun_parts', 1, true}, {'oil', 20, true}}},
            craft = {
                name = strings.events.make,
                sound = 'hacksaws',
                spendTime = 60,
                need = {{'izh', 1, true}, {'hacksaw_tag', 1}},
                give = {{'izh_short', 1, 0}}
            },
            craft1 = {
                name = strings.events.disassemble,
                count = 4,
                spendTime = 30,
                isConfirm = true,
                sound = 'craft',
                need = {{'izh', 1, true}},
                give = {{'shotgun_parts', 2}}
            },
            usedInBattle = {
                depreciation = 1.3333333333333333,
                give = {{'shotgun_shell', {0, 1}}}
            },
            broke = {give = {{'izh_broken', 1}}}
        }
    },
    -- Сломанное ружьё ИЖ
    {
        id = 'izh_broken',
        template = 'weapon_broken',
        addTags = {'not_package'},
        weight = 2800,
        imageFile = 'izh',
        events = {
            craft = {
                need = {{'izh_broken', 1, true}},
                give = {{'shotgun_parts', 1}}
            }
        }
    },
    -- Обрез ИЖ
    {
        id = 'izh_short',
        template = 'shotgun',
        addTags = {'heavy_weapon'},
        level = {'weapon', 26},
        ammo = {'shotgun_ammo', 1},
        weight = 1800,
        events = {
            repair = {need = {{'shotgun_parts', 1, true}, {'oil', 20, true}}},
            craft = {
                name = strings.events.disassemble,
                count = 4,
                spendTime = 30,
                isConfirm = true,
                sound = 'craft',
                need = {{'izh_short', 1, true}},
                give = {{'shotgun_parts', 1}}
            },
            usedInBattle = {
                depreciation = 1.3333333333333333,
                give = {{'shotgun_shell', {0, 1}}}
            },
            broke = {give = {{'shotgun_parts', 1}}}
        }
    },
    -- Ружьё ТОЗ
    {
        id = 'toz',
        template = 'shotgun',
        addTags = {'heavy_weapon'},
        level = {'weapon', 30},
        ammo = {'shotgun_ammo', 2},
        weight = 3000,
        events = {
            repair = {need = {{'shotgun_parts', 1, true}, {'oil', 20, true}}},
            craft = {
                name = strings.events.make,
                sound = 'hacksaws',
                spendTime = 60,
                need = {{'toz', 1, true}, {'hacksaw_tag', 1}},
                give = {{'toz_short', 1, 0}}
            },
            craft1 = {
                name = strings.events.disassemble,
                count = 4,
                spendTime = 30,
                isConfirm = true,
                sound = 'craft',
                need = {{'toz', 1, true}},
                give = {{'shotgun_parts', 2}}
            },
            usedInBattle = {
                depreciation = 1.3333333333333333,
                give = {{'shotgun_shell', {0, 1}}}
            },
            broke = {give = {{'toz_broken', 1}}}
        }
    },
    -- Сломанное ружьё ТОЗ
    {
        id = 'toz_broken',
        template = 'weapon_broken',
        addTags = {'not_package'},
        weight = 3000,
        imageFile = 'toz',
        events = {
            craft = {
                need = {{'toz_broken', 1, true}},
                give = {{'shotgun_parts', 1}}
            }
        }
    },
    -- Обрез ТОЗ
    {
        id = 'toz_short',
        template = 'shotgun',
        addTags = {'heavy_weapon'},
        level = {'weapon', 30},
        ammo = {'shotgun_ammo', 2},
        weight = 2000,
        events = {
            repair = {need = {{'shotgun_parts', 1, true}, {'oil', 20, true}}},
            craft = {
                name = strings.events.disassemble,
                count = 4,
                spendTime = 30,
                isConfirm = true,
                sound = 'craft',
                need = {{'toz_short', 1, true}},
                give = {{'shotgun_parts', 1}}
            },
            usedInBattle = {
                depreciation = 1.3333333333333333,
                give = {{'shotgun_shell', {0, 1}}}
            },
            broke = {give = {{'shotgun_parts', 1}}}
        }
    },
    -- Сайга
    {
        id = 'saiga',
        template = 'shotgun',
        addTags = {'heavy_weapon'},
        level = {'weapon', 38},
        ammo = {'shotgun_ammo', 3},
        weight = 3600,
        events = {
            repair = {need = {{'shotgun_parts', 1, true}, {'oil', 20, true}}},
            craft = {
                name = strings.events.disassemble,
                count = 4,
                spendTime = 30,
                isConfirm = true,
                sound = 'craft',
                need = {{'saiga', 1, true}},
                give = {{'shotgun_parts', 2}}
            },
            usedInBattle = {
                depreciation = 1.3333333333333333,
                give = {{'shotgun_shell', {0, 1}}}
            },
            broke = {give = {{'saiga_broken', 1}}}
        }
    },
    -- Сломанная Сайга
    {
        id = 'saiga_broken',
        template = 'weapon_broken',
        addTags = {'not_package'},
        weight = 3600,
        imageFile = 'saiga',
        events = {
            craft = {
                need = {{'saiga_broken', 1, true}},
                give = {{'shotgun_parts', 1}}
            }
        }
    },
    -- Винтовка Мосина
    {
        id = 'mosin',
        template = 'rifle',
        addTags = {'heavy_weapon'},
        level = {'weapon', 43},
        ammo = {'mosin_ammo', 1},
        weight = 4500,
        events = {
            repair = {need = {{'rifle_parts', 1, true}, {'oil', 20, true}}},
            craft = {
                name = strings.events.make,
                sound = 'hacksaws',
                spendTime = 60,
                need = {{'mosin', 1, true}, {'hacksaw_tag', 1}},
                give = {{'mosin_short', 1, 0}}
            },
            craft1 = {
                name = strings.events.disassemble,
                count = 4,
                spendTime = 30,
                isConfirm = true,
                sound = 'craft',
                need = {{'mosin', 1, true}},
                give = {{'rifle_parts', 2}}
            },
            usedInBattle = {
                depreciation = 1.3333333333333333,
                give = {{'mosin_shell', {0, 1}}}
            },
            broke = {give = {{'mosin_broken', 1}}}
        }
    },
    -- Сломанная винтовка Мосина
    {
        id = 'mosin_broken',
        template = 'weapon_broken',
        weight = 4500,
        imageFile = 'mosin',
        events = {
            craft = {
                need = {{'mosin_broken', 1, true}},
                give = {{'rifle_parts', 1}}
            }
        }
    },
    -- Обрез винтовки Мосина
    {
        id = 'mosin_short',
        template = 'pistol',
        addTags = {'heavy_weapon'},
        level = {'weapon', 43},
        ammo = {'mosin_ammo', 1},
        weight = 2300,
        events = {
            repair = {need = {{'rifle_parts', 1, true}, {'oil', 20, true}}},
            craft = {
                name = strings.events.disassemble,
                count = 4,
                spendTime = 30,
                isConfirm = true,
                sound = 'craft',
                need = {{'mosin_short', 1, true}},
                give = {{'rifle_parts', 1}}
            },
            usedInBattle = {
                depreciation = 1.4285714285714286,
                give = {{'mosin_shell', {0, 1}}}
            },
            broke = {give = {{'rifle_parts', 1}}}
        }
    },
    -- Винтовка СВТ
    {
        id = 'svt',
        template = 'rifle',
        addTags = {'heavy_weapon'},
        level = {'weapon', 60},
        ammo = {'mosin_ammo', 1},
        weight = 3800,
        events = {
            repair = {need = {{'rifle_parts', 1, true}, {'oil', 25, true}}},
            craft = {
                name = strings.events.disassemble,
                count = 4,
                spendTime = 30,
                isConfirm = true,
                sound = 'craft',
                need = {{'svt', 1, true}},
                give = {{'rifle_parts', 2}}
            },
            usedInBattle = {
                depreciation = 1.4285714285714286,
                give = {{'mosin_shell', {0, 1}}}
            },
            broke = {give = {{'svt_broken', 1}}}
        }
    },
    -- Сломанная СВТ
    {
        id = 'svt_broken',
        template = 'weapon_broken',
        weight = 3800,
        imageFile = 'svt',
        events = {
            craft = {
                need = {{'svt_broken', 1, true}},
                give = {{'rifle_parts', 1}}
            }
        }
    },
    -- Снайперская винтовка СВД
    {
        id = 'svd',
        template = 'rifle',
        addTags = {'heavy_weapon'},
        level = {'weapon', 69},
        ammo = {'mosin_ammo', 1},
        weight = 4300,
        events = {
            repair = {need = {{'rifle_parts', 1, true}, {'oil', 30, true}}},
            craft = {
                name = strings.events.disassemble,
                count = 4,
                spendTime = 30,
                isConfirm = true,
                sound = 'craft',
                need = {{'svd', 1, true}},
                give = {{'rifle_parts', 2}}
            },
            usedInBattle = {
                depreciation = 1.5384615384615385,
                give = {{'mosin_shell', {0, 1}}}
            },
            broke = {give = {{'svd_broken', 1}}}
        }
    },
    -- Сломанная СВД
    {
        id = 'svd_broken',
        template = 'weapon_broken',
        weight = 4300,
        imageFile = 'svd',
        events = {
            craft = {
                need = {{'svd_broken', 1, true}},
                give = {{'rifle_parts', 1}}
            }
        }
    },
    -- Пистолет-пулемёт ППС
    {
        id = 'pps',
        template = 'assault_rifle',
        addTags = {'light_weapon'},
        level = {'weapon', 26},
        ammo = {'tt_ammo', 3},
        weight = 3600,
        events = {
            repair = {need = {{'pistol_parts', 2, true}, {'oil', 20, true}}},
            craft = {
                name = strings.events.disassemble,
                count = 4,
                spendTime = 30,
                isConfirm = true,
                sound = 'craft',
                need = {{'pps', 1, true}},
                give = {{'pistol_parts', 4}}
            },
            usedInBattle = {
                depreciation = 1.4285714285714286,
                give = {{'tt_shell', {0, 3}}}
            },
            broke = {give = {{'pps_broken', 1, 0}}}
        }
    },
    -- Сломанный ППС
    {
        id = 'pps_broken',
        template = 'weapon_broken',
        weight = 3600,
        imageFile = 'pps',
        events = {
            craft = {
                need = {{'pps_broken', 1, true}},
                give = {{'pistol_parts', 2}}
            }
        }
    },
    -- Пистолет-пулемёт ППШ
    {
        id = 'ppsh',
        template = 'assault_rifle',
        addTags = {'light_weapon'},
        level = {'weapon', 40},
        ammo = {'tt_ammo', 3},
        weight = 5300,
        events = {
            repair = {need = {{'pistol_parts', 2, true}, {'oil', 25, true}}},
            craft = {
                name = strings.events.disassemble,
                count = 4,
                spendTime = 30,
                isConfirm = true,
                sound = 'craft',
                need = {{'ppsh', 1, true}},
                give = {{'pistol_parts', 4}}
            },
            usedInBattle = {
                depreciation = 1.6666666666666667,
                give = {{'tt_shell', {0, 3}}}
            },
            broke = {give = {{'ppsh_broken', 1, 0}}}
        }
    },
    -- Сломанный ППШ
    {
        id = 'ppsh_broken',
        template = 'weapon_broken',
        weight = 5000,
        imageFile = 'ppsh',
        events = {
            craft = {
                need = {{'ppsh_broken', 1, true}},
                give = {{'pistol_parts', 2}}
            }
        }
    },
    -- Автомат АКС-74У
    {
        id = 'aks74u',
        template = 'assault_rifle',
        addTags = {'light_weapon'},
        level = {'weapon', 48},
        ammo = {'ak74_ammo', 3},
        imageFile = 'aks74u',
        weight = 3000,
        events = {
            repair = {
                need = {{'assault_rifle_parts', 1, true}, {'oil', 30, true}}
            },
            craft = {
                name = strings.events.disassemble,
                count = 4,
                spendTime = 30,
                isConfirm = true,
                sound = 'craft',
                need = {{'aks74u', 1, true}},
                give = {{'assault_rifle_parts', 2}}
            },
            usedInBattle = {
                depreciation = 1.6666666666666667,
                give = {{'ak74_shell', {0, 3}}}
            },
            broke = {give = {{'aks74u_broken', 1, 0}}}
        }
    },
    -- Сломанный АКС-74У
    {
        id = 'aks74u_broken',
        template = 'weapon_broken',
        weight = 3500,
        imageFile = 'aks74u',
        events = {
            craft = {
                need = {{'aks74u_broken', 1, true}},
                give = {{'assault_rifle_parts', 1}}
            }
        }
    },
    -- Автомат АК-74
    {
        id = 'ak74_single',
        template = 'assault_rifle',
        isTagIcon = true,
        addTags = {'light_weapon'},
        level = {'weapon', 57},
        ammo = {'ak74_ammo', 5},
        imageFile = 'ak74',
        weight = 3500,
        weaponId = 'ak74',
        events = {
            repair = {
                need = {{'assault_rifle_parts', 1, true}, {'oil', 30, true}}
            },
            craft = {
                name = strings.events.disassemble,
                count = 4,
                spendTime = 30,
                isConfirm = true,
                sound = 'craft',
                need = {{'ak74_single', 1, true}},
                give = {{'assault_rifle_parts', 3}}
            },
            usedInBattle = {
                depreciation = 1.4285714285714286,
                give = {{'ak74_shell', {0, 5}}}
            },
            broke = {give = {{'ak74_broken', 1, 0}}}
        }
    },
    -- Сломанный АК-74
    {
        id = 'ak74_broken',
        template = 'weapon_broken',
        weight = 3500,
        imageFile = 'ak74',
        events = {
            craft = {
                need = {{'ak74_broken', 1, true}},
                give = {{'assault_rifle_parts', 1}}
            }
        }
    },
    -- Автомат АН-94 «Абакан»
    {
        id = 'abakan',
        template = 'assault_rifle',
        addTags = {'light_weapon', 'not_package'},
        level = {'weapon', 63},
        ammo = {'ak74_ammo', 6},
        weight = 3850,
        events = {
            repair = {
                need = {{'assault_rifle_parts', 1, true}, {'oil', 30, true}}
            },
            usedInBattle = {
                depreciation = 1.4285714285714286,
                give = {{'ak74_shell', {0, 5}}}
            },
            broke = {give = {{'abakan_broken', 1, 0}}}
        }
    },
    -- Сломанный «Абакан»
    {
        id = 'abakan_broken',
        template = 'weapon_broken',
        addTags = {'not_package'},
        weight = 3850,
        imageFile = 'abakan',
        events = {
            craft = {
                need = {{'abakan_broken', 1, true}},
                give = {{'assault_rifle_parts', 1}}
            }
        }
    },
    -- Ручной пулемёт РПК-74
    {
        id = 'rpk74',
        template = 'assault_rifle',
        addTags = {'heavy_weapon'},
        level = {'weapon', 65},
        ammo = {'ak74_ammo', 5},
        weight = 5150,
        events = {
            repair = {
                need = {{'assault_rifle_parts', 2, true}, {'oil', 50, true}}
            },
            craft = {
                name = strings.events.disassemble,
                count = 4,
                spendTime = 30,
                isConfirm = true,
                sound = 'craft',
                need = {{'rpk74', 1, true}},
                give = {{'assault_rifle_parts', 4}}
            },
            usedInBattle = {depreciation = 1, give = {{'ak74_shell', {0, 10}}}},
            broke = {give = {{'rpk74_broken', 1}}}
        }
    },
    -- Сломанный РПК-74
    {
        id = 'rpk74_broken',
        template = 'weapon_broken',
        weight = 5150,
        imageFile = 'rpk74',
        events = {
            craft = {
                need = {{'rpk74_broken', 1, true}},
                give = {{'assault_rifle_parts', 2}}
            }
        }
    },
    -- Пулемёт Дегтярёва (ДП)
    {
        id = 'dp',
        template = 'assault_rifle',
        addTags = {'heavy_weapon'},
        level = {'weapon', 75},
        ammo = {'mosin_ammo', 5},
        weight = 10000,
        events = {
            repair = {
                need = {{'machine_gun_parts', 1, true}, {'oil', 100, true}}
            },
            craft = {
                name = strings.events.disassemble,
                count = 4,
                spendTime = 30,
                isConfirm = true,
                sound = 'craft',
                need = {{'dp', 1, true}},
                give = {{'machine_gun_parts', 2}}
            },
            usedInBattle = {
                depreciation = 0.8333333333333334,
                give = {{'mosin_shell', {0, 10}}}
            },
            broke = {give = {{'dp_broken', 1, 0}}}
        }
    },
    -- Сломанный ДП
    {
        id = 'dp_broken',
        template = 'weapon_broken',
        weight = 10000,
        imageFile = 'dp',
        events = {
            craft = {
                need = {{'dp_broken', 1, true}},
                give = {{'machine_gun_parts', 1}}
            }
        }
    },
    -- Пулемёт Калашникова (ПК)
    {
        id = 'pk',
        template = 'assault_rifle',
        addTags = {'heavy_weapon'},
        level = {'weapon', 85},
        ammo = {'mosin_ammo', 5},
        weight = 9000,
        events = {
            repair = {
                need = {{'machine_gun_parts', 1, true}, {'oil', 100, true}}
            },
            craft = {
                name = strings.events.disassemble,
                count = 4,
                spendTime = 30,
                isConfirm = true,
                sound = 'craft',
                need = {{'pk', 1, true}},
                give = {{'machine_gun_parts', 3}}
            },
            usedInBattle = {
                depreciation = 0.6666666666666666,
                give = {{'mosin_shell', {0, 10}}}
            },
            broke = {give = {{'pk_broken', 1, 0}}}
        }
    },
    -- Сломанный ПК
    {
        id = 'pk_broken',
        template = 'weapon_broken',
        weight = 9000,
        imageFile = 'pk',
        events = {
            craft = {
                need = {{'pk_broken', 1, true}},
                give = {{'machine_gun_parts', 1}}
            }
        }
    },
    -- Пулемёт ГШГ
    {
        id = 'gshg',
        template = 'assault_rifle',
        addTags = {'important_tag', 'heavy_weapon'},
        ammo = {'mosin_ammo', 10},
        weight = 22000,
        events = {
            repair = {
                need = {{'machine_gun_parts', 1, true}, {'oil', 100, true}}
            },
            usedInBattle = {
                depreciation = 0.4,
                give = {{'mosin_shell', {0, 10}}}
            },
            broke = {give = {{'gshg_broken', 1, 0}}}
        }
    },
    -- Сломанный ГШГ
    {
        id = 'gshg_broken',
        template = 'weapon_broken',
        addTags = {'important_tag'},
        weight = 22000,
        imageFile = 'gshg',
        events = {
            craft = {
                name = strings.events.repair,
                need = {
                    {'gshg_broken', 1, true},
                    {'machine_gun_parts', 10, true},
                    {'oil', 1000, true},
                    {'tools_tag', 1}
                },
                give = {{'gshg', 1}}
            }
        }
    },
    -- Гранатомёт РПГ-7
    {
        id = 'rpg7',
        template = 'launcher',
        addTags = {'heavy_weapon'},
        level = {'weapon', 90},
        ammo = {'rpg7_ammo', 1},
        weight = 6300,
        events = {repair = false, usedInBattle = {depreciation = 4}}
    },
    -- Самодельный ракетомёт
    {
        id = 'rocket_launcher',
        template = 'launcher',
        addTags = {'heavy_weapon'},
        level = {'weapon', 81},
        ammo = {'rocket_launcher_ammo', 1},
        weight = 2200,
        events = {
            repair = {
                need = {
                    {'glue', 10, true},
                    {'scrap_metal', 10, true},
                    {'welder', 1},
                    {'generator_fuel', 1},
                    {'tools_tag', 1}
                }
            },
            usedInBattle = {depreciation = 5}
        }
    },
    -- Граната Ф-1
    {
        id = 'f_1',
        template = 'grenade',
        battle_level = 8,
        ammo = {'f_1', 1},
        addTags = {'explosive', 'grenade', 'heavy_weapon'},
        weight = 600,
        events = {
            craft = {
                name = strings.events.disassemble,
                count = 4,
                spendTime = 20,
                sound = 'craft',
                need = {{'f_1', 1, true}, {'tools_tag', 1}},
                give = {{'plastic_explosives', 1}, {'scrap_metal', 3}}
            },
            use2 = {
                access = {needState = {{'radiation', 100, '>'}}},
                need = {{'f_1', 1, true}},
                name = strings.events.pullpin,
                character = {hp = -999}
            }
        }
    },
    -- Светошумовая граната
    {
        id = 'flash_grenade',
        template = 'grenade',
        addTags = {'heavy_weapon'},
        battle_level = 8,
        ammo = {'flash_grenade', 1},
        weight = 300
    },
    -- Коктейль Молотова
    {
        id = 'cocktail_molotov',
        template = 'grenade',
        addTags = {'heavy_weapon'},
        ammo = {'cocktail_molotov', 1},
        weight = 600,
        events = {}
    },
    -- Пороховая граната
    {
        id = 'gunpowder_grenade',
        template = 'grenade',
        addTags = {'heavy_weapon'},
        ammo = {'gunpowder_grenade', 1},
        weight = 400,
        events = {}
    }
}
if TEST_BUILD then
    -- Тестовый предмет (только в тестовой сборке)
    item_list[#item_list + 1] = {
        id = 't34',
        imageFile = 'gold_crowbar',
        tagList = {'weapon', 'equipment_related', 'heavy_weapon'},
        weight = 1,
        events = {
            heroLight = {value = 3, needWear = true},
            radiationResist = {needWear = true, value = 1},
            use = {name = 'Умереть', character = {hp = -1000}},
            craft = {
                spendTime = 1,
                name = 'Прокачать все навыки',
                exp = 100
            },
            craft2 = {
                spendTime = 1,
                name = 'Все оружие',
                action = function()
                    main.itemlist.addAllToInventory('weapon', 2)
                end
            },
            craft3 = {
                spendTime = 1,
                name = 'Вся броня',
                action = function()
                    main.itemlist.addAllToInventory('armor', 2)
                end
            },
            craft4 = {
                spendTime = 1,
                name = 'Вся еда',
                action = function()
                    main.itemlist.addAllToInventory('food', 2)
                end
            },
            craft5 = {
                spendTime = 1,
                name = 'Весь транспорт',
                action = function()
                    main.itemlist.addAllToInventory('transport', 2)
                end
            },
            craft6 = {
                spendTime = 20,
                name = 'Все предметы',
                action = function()
                    main.itemlist.addAllToInventory(nil, 1000)
                end
            }
        }
    }
end
return item_list
