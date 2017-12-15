resource "aws_iam_group_membership" "governor-administrator" {
  name  = "governor-administrator"
  group = "${aws_iam_group.governor-administrator.id}"

  users = [
    "${aws_iam_user.david_sundberg.name}",
    "${aws_iam_user.devon_peters.name}",
    "${aws_iam_user.shaun_kasperowicz.name}",
    "${aws_iam_user.peter_auv.name}",
    "${aws_iam_user.shimran_george.name}",
    "${aws_iam_user.sylvester_mitchell.name}",
  ]
}

resource "aws_iam_group_membership" "data-administrator" {
  name  = "data-administrator"
  group = "${aws_iam_group.data-administrator.id}"

  users = [
    "${aws_iam_user.chris_valaas.name}",
    "${aws_iam_user.ed_snajder.name}",
    "${aws_iam_user.david_sundberg.name}",
    "${aws_iam_user.niv_basson.name}",
    "${aws_iam_user.devon_peters.name}",
    "${aws_iam_user.shaun_kasperowicz.name}",
    "${aws_iam_user.sylvester_mitchell.name}",
    "${aws_iam_user.tim_dooher.name}",
    "${aws_iam_user.gautam_manohar.name}",
    "${aws_iam_user.daniel_harada.name}",
    "${aws_iam_user.manu_kaliprasad.name}",
    "${aws_iam_user.sergei_shnerson.name}",
    "${aws_iam_user.mario_marin.name}",
    "${aws_iam_user.muzammil_sayed.name}",
  ]
}

resource "aws_iam_group_membership" "microservices-administrator" {
  name  = "microservices-administrator"
  group = "${aws_iam_group.microservices-administrator.id}"

  users = [
    "${aws_iam_user.david_sundberg.name}",
    "${aws_iam_user.devon_peters.name}",
    "${aws_iam_user.shaun_kasperowicz.name}",
    "${aws_iam_user.sylvester_mitchell.name}",
    "${aws_iam_user.peter_auv.name}",
    "${aws_iam_user.chris_valaas.name}",
    "${aws_iam_user.ed_snajder.name}",
    "${aws_iam_user.niv_basson.name}",
    "${aws_iam_user.yuval_varkel.name}",
    "${aws_iam_user.tim_dooher.name}",
    "${aws_iam_user.gautam_manohar.name}",
    "${aws_iam_user.murali_seetharaman.name}",
    "${aws_iam_user.shimran_george.name}",
    "${aws_iam_user.daniel_harada.name}",
  ]
}

# members to be removed once consolidated IAM stuff is done
resource "aws_iam_group_membership" "reco-administrator" {
  name  = "reco-administrator"
  group = "${aws_iam_group.reco-administrator.id}"

  users = [
    "${aws_iam_user.david_sundberg.name}",
    "${aws_iam_user.devon_peters.name}",
    "${aws_iam_user.shaun_kasperowicz.name}",
    "${aws_iam_user.sylvester_mitchell.name}",
    "${aws_iam_user.ed_snajder.name}",
    "${aws_iam_user.chris_valaas.name}",
    "${aws_iam_user.peter_auv.name}",
    "${aws_iam_user.bruce_downs.name}",
    "${aws_iam_user.david_brown.name}",
    "${aws_iam_user.murali_seetharaman.name}",
    "${aws_iam_user.victor_akinwande.name}",
  ]
}

resource "aws_iam_group_membership" "jcx-administrator" {
  name  = "jcx-administrator"
  group = "${aws_iam_group.jcx-administrator.id}"

  users = [
    "${aws_iam_user.shaun_kasperowicz.name}",
    "${aws_iam_user.sylvester_mitchell.name}",
    "${aws_iam_user.peter_auv.name}",
    "${aws_iam_user.benjamin_sherman.name}",
    "${aws_iam_user.matt_pate.name}",
    "${aws_iam_user.aaron_shaver.name}",
    "${aws_iam_user.srikanth_gauthareddy.name}",
    "${aws_iam_user.niels_bischof.name}",
    "${aws_iam_user.shimran_george.name}",
    "${aws_iam_user.zsolt_katona.name}",
    "${aws_iam_user.sana_majeed.name}",
  ]
}

resource "aws_iam_group_membership" "ps-administrator" {
  name  = "ps-administrator"
  group = "${aws_iam_group.ps-administrator.id}"

  users = [
    "${aws_iam_user.david_sundberg.name}",
    "${aws_iam_user.devon_peters.name}",
    "${aws_iam_user.shaun_kasperowicz.name}",
    "${aws_iam_user.sylvester_mitchell.name}",
  ]
}

resource "aws_iam_group_membership" "infra-administrator" {
  name  = "infra-administrator"
  group = "${aws_iam_group.infra-administrator.id}"

  users = [
    "${aws_iam_user.david_sundberg.name}",
    "${aws_iam_user.devon_peters.name}",
    "${aws_iam_user.shaun_kasperowicz.name}",
    "${aws_iam_user.sylvester_mitchell.name}",
    "${aws_iam_user.peter_auv.name}",
    "${aws_iam_user.shimran_george.name}",
    "${aws_iam_user.niv_basson.name}",
  ]
}

resource "aws_iam_group_membership" "cloudalytics-administrator" {
  name  = "cloudalytics-administrator"
  group = "${aws_iam_group.cloudalytics-administrator.id}"

  users = [
    "${aws_iam_user.guro_bokum.name}",
]
}

resource "aws_iam_group_membership" "cloudsearch-administrator" {
  name  = "cloudsearch-administrator"
  group = "${aws_iam_group.cloudsearch-administrator.id}"

  users = [
    "${aws_iam_user.alexey_zotov.name}",
    "${aws_iam_user.robert_browning.name}",
    "${aws_iam_user.benji_smith.name}",
  ]
}

resource "aws_iam_group_membership" "tardis-administrator" {
  name  = "tardis-administrator"
  group = "${aws_iam_group.tardis-administrator.id}"

  users = [
    "${aws_iam_user.michael_lilley.name}",
    "${aws_iam_user.larry_peterson.name}",
  ]
}

resource "aws_iam_group_membership" "baas-administrator" {
  name  = "baas-administrator"
  group = "${aws_iam_group.baas-administrator.id}"

  users = []
}

resource "aws_iam_group_membership" "israel-administrator" {
  name  = "israel-administrator"
  group = "${aws_iam_group.israel-administrator.id}"

  users = [
    "${aws_iam_user.yuval_varkel.name}",
    "${aws_iam_user.stas_spivak.name}",
    "${aws_iam_user.tzvika_stein.name}",
    "${aws_iam_user.bar_avidan.name}",
    "${aws_iam_user.matan_shukry.name}",
    "${aws_iam_user.shiran_dadon.name}",
    "${aws_iam_user.rami_moshe.name}",
    "${aws_iam_user.moria_cohen.name}",
    "${aws_iam_user.tom_doron.name}",
    "${aws_iam_user.michael_lilley.name}",
    "${aws_iam_user.lior_tager.name}",
    "${aws_iam_user.stas_panchenko.name}",
    "${aws_iam_user.dor_graidy.name}",
    "${aws_iam_user.david_meoded.name}",
    "${aws_iam_user.tejinder_jheeta.name}",
    "${aws_iam_user.niv_basson.name}",
    "${aws_iam_user.slava_fiodorov.name}",
  ]
}

resource "aws_iam_group_membership" "mako-administrator" {
  name  = "mako-administrator"
  group = "${aws_iam_group.mako-administrator.id}"

  users = [
    "${aws_iam_user.frank_davalos.name}",
    "${aws_iam_user.david_throckmorton.name}",
    "${aws_iam_user.paul_wroe.name}",
    "${aws_iam_user.adam_luckey.name}",
    "${aws_iam_user.shimran_george.name}",
    "${aws_iam_user.andras_liter.name}",
  ]
}

resource "aws_iam_group_membership" "jive-w-administrator" {
  name  = "jive-w-administrator"
  group = "${aws_iam_group.jive-w-administrator.id}"

  users = [
    "${aws_iam_user.shaun_kasperowicz.name}",
    "${aws_iam_user.sylvester_mitchell.name}",
    "${aws_iam_user.david_sundberg.name}",
    "${aws_iam_user.peter_auv.name}",
  ]
}

resource "aws_iam_group_membership" "partnercollaboration-administrator" {
  name  = "partnercollaboration-administrator"
  group = "${aws_iam_group.partnercollaboration-administrator.id}"

  users = [
    "${aws_iam_user.peter_auv.name}",
  ]
}

resource "aws_iam_group_membership" "support-administrator" {
  name  = "support-administrator"
  group = "${aws_iam_group.support-administrator.id}"

  users = [
    "${aws_iam_user.devon_peters.name}",
    "${aws_iam_user.shaun_kasperowicz.name}",
  ]
}

resource "aws_iam_group_membership" "ps-sandbox-administrator" {
  name  = "ps-sandbox-administrator"
  group = "${aws_iam_group.ps-sandbox-administrator.id}"

  users = [
    "${aws_iam_user.peter_auv.name}",
    "${aws_iam_user.arnold_benson.name}",
    "${aws_iam_user.erwin_driessen.name}",
    "${aws_iam_user.matt_hill.name}",
    "${aws_iam_user.sai_kolli.name}",
  ]
}

resource "aws_iam_group_membership" "hosting-pipeline-administrator" {
  name  = "hosting-pipeline-administrator"
  group = "${aws_iam_group.hosting-pipeline-administrator.id}"

  users = [
    "${aws_iam_user.david_sundberg.name}",
    "${aws_iam_user.david_throckmorton.name}",
    "${aws_iam_user.paul_wroe.name}",
    "${aws_iam_user.adam_luckey.name}",
    "${aws_iam_user.frank_davalos.name}",
    "${aws_iam_user.don_forbes.name}",
    "${aws_iam_user.devon_peters.name}",
  ]
}

resource "aws_iam_group_membership" "bikou-administrator" {
  name  = "bikou-administrator"
  group = "${aws_iam_group.bikou-administrator.id}"

  users = [
    "${aws_iam_user.david_sundberg.name}",
  ]
}

resource "aws_iam_group_membership" "reco-sandbox-administrator" {
  name  = "reco-sandbox-administrator"
  group = "${aws_iam_group.reco-sandbox-administrator.id}"

  users = [
    "${aws_iam_user.peter_auv.name}",
    "${aws_iam_user.david_brown.name}",
    "${aws_iam_user.bruce_downs.name}",
    "${aws_iam_user.craig_mcclanahan.name}",
    "${aws_iam_user.rahul_sharma.name}",
    "${aws_iam_user.robert_browning.name}",
    "${aws_iam_user.victor_akinwande.name}",
    "${aws_iam_user.murali_seetharaman.name}",
  ]
}
