$modelname "G:\3D Files\HalfLife\Project\Robots\Smd7of9\7of9.mdl"
$cd "\3D Files\HalfLife\Project\Robots\Smd7of9\"
$cdtexture "\3D Files\HalfLife\Project\Robots\Smd7of9\"
$cliptotextures

$scale 1.0

// 3 attachments
$attachment 0 "Bip01 R Hand" 20.000000 2.000000 5.000000 
$attachment 1 "Bip01 R Hand" 15.000000 1.500000 3.750000 
$attachment 2 "Bip01 R Hand" 30.000000 3.000000 7.500000 

// 4 bone controllers
$controller 0 "Bip01 Spine" XR -30 30
$controller 1 "Bip01 Spine1" XR -30 30
$controller 2 "Bip01 Spine2" XR -30 30
$controller 3 "Bip01 Spine3" XR -30 30

// 20 hit boxes
$hbox 3 "Bip01 Pelvis" -4.690000 -4.440000 -6.750000  4.000000 5.560000 6.750000
$hbox 6 "Bip01 L Leg" 2.660000 -3.690000 -3.090000  18.160000 4.880000 3.310000
$hbox 6 "Bip01 L Leg1" 0.380000 -3.970000 -2.840000  17.600000 4.000000 2.940000
$hbox 6 "Bip01 L Foot" -0.590000 -2.340000 -2.630000  3.790000 8.000000 2.190000
$hbox 7 "Bip01 R Leg" 2.470000 -3.690000 -3.160000  18.129999 4.880000 3.380000
$hbox 7 "Bip01 R Leg1" 0.310000 -3.970000 -2.840000  17.600000 3.940000 2.970000
$hbox 7 "Bip01 R Foot" -0.560000 -2.340000 -2.190000  3.810000 8.000000 2.660000
$hbox 3 "Bip01 Spine1" -3.250000 -5.500000 -5.500000  4.830000 5.500000 5.500000
$hbox 2 "Bip01 Spine2" -0.060000 -5.530000 -7.590000  8.000000 7.000000 7.590000
$hbox 2 "Bip01 Spine3" -2.250000 -6.810000 -6.310000  6.500000 5.090000 6.310000
$hbox 2 "Bip01 Neck" -3.110000 -1.500000 -3.000000  2.050000 3.500000 3.000000
$hbox 1 "Bip01 Head" 0.090000 -3.660000 -3.000000  8.410000 5.090000 3.000000
$hbox 4 "Bip01 L Arm" 0.940000 -2.880000 -4.130000  5.440000 4.280000 3.500000
$hbox 4 "Bip01 L Arm1" -2.160000 -2.340000 -2.560000  11.560000 3.410000 2.380000
$hbox 4 "Bip01 L Arm2" 0.590000 -1.810000 -2.190000  10.750000 2.840000 2.410000
$hbox 4 "Bip01 L Hand" 0.000000 -1.000000 -2.000000  3.000000 1.500000 3.500000
$hbox 5 "Bip01 R Arm" 1.380000 -2.840000 -3.560000  5.690000 4.310000 4.310000
$hbox 5 "Bip01 R Arm1" -1.880000 -2.470000 -2.160000  11.810000 3.280000 2.810000
$hbox 5 "Bip01 R Arm2" 0.440000 -1.970000 -2.340000  10.590000 2.720000 2.220000
$hbox 5 "Bip01 R Hand" 0.000000 -1.000000 -2.000000  3.000000 1.500000 3.500000

$bodygroup body
{
studio "../dmatch/lowcount/7of9/7of9"
}

// 77 sequences
$sequence look_idle "look_idle" loop fps 14 ACT_IDLE 2 
$sequence idle "idle" loop fps 14 ACT_IDLE 1 
$sequence deep_idle "deep_idle" loop fps 12 ACT_IDLE 4 
$sequence run2 "run2" LX loop fps 40 ACT_RUN 1 
$sequence walk2handed "walk2handed" LX loop fps 26 ACT_WALK 1 
$sequence 2handshoot "2handshoot" fps 20 ACT_RANGE_ATTACK1 1 
$sequence crawl "crawl" LX loop fps 22 ACT_CROUCH 1 
$sequence crouch_idle "crouch_idle" loop fps 12 ACT_CROUCHIDLE 1 
$sequence jump "jump" fps 30 ACT_HOP 1 
$sequence long_jump "long_jump" LX fps 24 ACT_LEAP 1 
$sequence swim "swim" loop fps 14 ACT_SWIM 1 
$sequence treadwater "treadwater" loop fps 14 ACT_HOVER 1 
$sequence run "run" LX loop fps 31 
$sequence walk "walk" LX loop fps 31 
$sequence aim_2 "aim_2_blend1" "aim_2_blend2" loop fps 14 blend XR -45 45 
$sequence shoot_2 "shoot_2_blend1" "shoot_2_blend2" loop fps 14 blend XR -45 45 
$sequence aim_1 "aim_1_blend1" "aim_1_blend2" loop fps 14 blend XR -45 45 
$sequence shoot_1 "shoot_1_blend1" "shoot_1_blend2" loop fps 14 blend XR -45 45 
$sequence die_simple "die_simple" fps 22 ACT_DIESIMPLE 1 { event 2001 9 } 
$sequence die_backwards1 "die_backwards1" fps 26 ACT_DIEBACKWARD 4 { event 2001 13 } 
$sequence die_backwards "die_backwards" fps 30 ACT_DIEBACKWARD 1 { event 2001 15 } 
$sequence die_fordwards1 "die_fordwards1" fps 30 ACT_DIEFORWARD 1 { event 2001 16 } 
$sequence headshot "headshot" fps 24 ACT_DIE_HEADSHOT 4 { event 2001 22 } 
$sequence die_spin "die_spin" fps 30 ACT_DIE_HEADSHOT 1 { event 2001 16 } 
$sequence gutshot "gutshot" fps 26 ACT_DIE_GUTSHOT 1 { event 2001 22 } 
$sequence ref_aim_crowbar "ref_aim_crowbar_blend1" "ref_aim_crowbar_blend2" loop fps 12 blend XR -45 45 
$sequence ref_shoot_crowbar "ref_shoot_crowbar_blend1" "ref_shoot_crowbar_blend2" fps 24 blend XR -45 45 
$sequence crouch_aim_crowbar "crouch_aim_crowbar_blend1" "crouch_aim_crowbar_blend2" loop fps 12 blend XR -45 45 
$sequence crouch_shoot_crowbar "crouch_shoot_crowbar_blend1" "crouch_shoot_crowbar_blend2" fps 24 blend XR -45 45 
$sequence ref_aim_trip "ref_aim_trip_blend1" "ref_aim_trip_blend2" loop fps 12 blend XR -45 45 
$sequence ref_shoot_trip "ref_shoot_trip_blend1" "ref_shoot_trip_blend2" fps 18 blend XR -45 45 
$sequence crouch_aim_trip "crouch_aim_trip_blend1" "crouch_aim_trip_blend2" loop fps 12 blend XR -45 45 
$sequence crouch_shoot_trip "crouch_shoot_trip_blend1" "crouch_shoot_trip_blend2" fps 16 blend XR -45 45 
$sequence ref_aim_onehanded "ref_aim_onehanded_blend1" "ref_aim_onehanded_blend2" loop fps 12 blend XR -50 35 
$sequence ref_shoot_onehanded "ref_shoot_onehanded_blend1" "ref_shoot_onehanded_blend2" fps 16 blend XR -50 35 { event 5011 0 "21" } 
$sequence crouch_aim_onehanded "crouch_aim_onehanded_blend1" "crouch_aim_onehanded_blend2" loop fps 12 blend XR -50 35 
$sequence crouch_shoot_onehanded "crouch_shoot_onehanded_blend1" "crouch_shoot_onehanded_blend2" fps 16 blend XR -50 35 { event 5011 0 "21" } 
$sequence ref_aim_python "ref_aim_python_blend1" "ref_aim_python_blend2" loop fps 12 blend XR -50 35 
$sequence ref_shoot_python "ref_shoot_python_blend1" "ref_shoot_python_blend2" fps 16 blend XR -50 35 { event 5011 0 "31" } 
$sequence crouch_aim_python "crouch_aim_python_blend1" "crouch_aim_python_blend2" loop fps 12 blend XR -50 35 
$sequence crouch_shoot_python "crouch_shoot_python_blend1" "crouch_shoot_python_blend2" fps 16 blend XR -50 35 { event 5011 0 "31" } 
$sequence ref_aim_shotgun "ref_aim_shotgun_blend1" "ref_aim_shotgun_blend2" loop fps 12 blend XR -45 45 
$sequence ref_shoot_shotgun "ref_shoot_shotgun_blend1" "ref_shoot_shotgun_blend2" fps 15 blend XR -45 45 { event 5021 0 "51" } 
$sequence crouch_aim_shotgun "crouch_aim_shotgun_blend1" "crouch_aim_shotgun_blend2" loop fps 12 blend XR -45 45 
$sequence crouch_shoot_shotgun "crouch_shoot_shotgun_blend1" "crouch_shoot_shotgun_blend2" fps 15 blend XR -45 45 { event 5021 0 "51" } 
$sequence ref_aim_gauss "ref_aim_gauss_blend1" "ref_aim_gauss_blend2" loop fps 12 blend XR -45 45 
$sequence ref_shoot_gauss "ref_shoot_gauss_blend1" "ref_shoot_gauss_blend2" fps 15 blend XR -45 45 
$sequence crouch_aim_gauss "crouch_aim_gauss_blend1" "crouch_aim_gauss_blend2" loop fps 12 blend XR -45 45 
$sequence crouch_shoot_gauss "crouch_shoot_gauss_blend1" "crouch_shoot_gauss_blend2" fps 15 blend XR -45 45 
$sequence ref_aim_mp5 "ref_aim_mp5_blend1" "ref_aim_mp5_blend2" loop fps 12 blend XR -45 45 
$sequence ref_shoot_mp5 "ref_shoot_mp5_blend1" "ref_shoot_mp5_blend2" loop fps 20 blend XR -45 45 { event 5001 0 "40" } 
$sequence crouch_aim_mp5 "crouch_aim_mp5_blend1" "crouch_aim_mp5_blend2" loop fps 12 blend XR -30 40 
$sequence crouch_shoot_mp5 "crouch_shoot_mp5_blend1" "crouch_shoot_mp5_blend2" loop fps 20 blend XR -30 40 { event 5001 0 "40" } 
$sequence ref_aim_rpg "ref_aim_rpg_blend1" "ref_aim_rpg_blend2" loop fps 12 blend XR -45 40 
$sequence ref_shoot_rpg "ref_shoot_rpg_blend1" "ref_shoot_rpg_blend2" fps 18 blend XR -45 40 
$sequence crouch_aim_rpg "crouch_aim_rpg_blend1" "crouch_aim_rpg_blend2" loop fps 12 blend XR -45 40 
$sequence crouch_shoot_rpg "crouch_shoot_rpg_blend1" "crouch_shoot_rpg_blend2" fps 18 blend XR -45 40 
$sequence ref_aim_egon "ref_aim_egon_blend1" "ref_aim_egon_blend2" loop fps 12 blend XR -45 35 
$sequence ref_shoot_egon "ref_shoot_egon_blend1" "ref_shoot_egon_blend2" loop fps 18 blend XR -45 35 
$sequence crouch_aim_egon "crouch_aim_egon_blend1" "crouch_aim_egon_blend2" loop fps 12 blend XR -45 45 
$sequence crouch_shoot_egon "crouch_shoot_egon_blend1" "crouch_shoot_egon_blend2" loop fps 18 blend XR -45 45 
$sequence ref_aim_squeak "ref_aim_squeak_blend1" "ref_aim_squeak_blend2" loop fps 12 blend XR -45 45 
$sequence ref_shoot_squeak "ref_shoot_squeak_blend1" "ref_shoot_squeak_blend2" fps 14 blend XR -45 45 
$sequence crouch_aim_squeak "crouch_aim_squeak_blend1" "crouch_aim_squeak_blend2" loop fps 12 blend XR -45 45 
$sequence crouch_shoot_squeak "crouch_shoot_squeak_blend1" "crouch_shoot_squeak_blend2" fps 14 blend XR -45 45 
$sequence ref_aim_hive "ref_aim_hive_blend1" "ref_aim_hive_blend2" loop fps 12 blend XR -45 45 
$sequence ref_shoot_hive "ref_shoot_hive_blend1" "ref_shoot_hive_blend2" fps 15 blend XR -45 45 
$sequence crouch_aim_hive "crouch_aim_hive_blend1" "crouch_aim_hive_blend2" loop fps 12 blend XR -45 45 
$sequence crouch_shoot_hive "crouch_shoot_hive_blend1" "crouch_shoot_hive_blend2" fps 15 blend XR -45 45 
$sequence ref_aim_bow "ref_aim_bow_blend1" "ref_aim_bow_blend2" loop fps 12 blend XR -45 45 
$sequence ref_shoot_bow "ref_shoot_bow_blend1" "ref_shoot_bow_blend2" fps 16 blend XR -45 45 
$sequence crouch_aim_bow "crouch_aim_bow_blend1" "crouch_aim_bow_blend2" loop fps 12 blend XR -45 45 
$sequence crouch_shoot_bow "crouch_shoot_bow_blend1" "crouch_shoot_bow_blend2" fps 16 blend XR -45 45 
$sequence deadback "deadback" fps 10 
$sequence deadsitting "deadsitting" fps 10 
$sequence deadstomach "deadstomach" fps 10 
$sequence deadtable "deadtable" fps 10 
