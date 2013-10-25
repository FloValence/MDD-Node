mongoose = require 'mongoose'
Schema = mongoose.Schema

# models
exports.DoseSet = mongoose.model 'DoseSet', new Schema
	title: String
	date: String
	url: String
	all: String
	selected: String
	tags: String
	favorited: Boolean

exports.Dose = mongoose.model 'Dose', new Schema
	comments_count: Number
	created_at: String
	did: Number
	height: Number
	image_400_url: String
	image_teaser_url: String
	image_url: String
	likes_count: Number
	player: Object
	rebound_source_id: Number
	rebounds_count: Number
	short_url: String
	title: String
	url: String
	views_count: Number
	width: Number
	userId: String

exports.User = mongoose.model 'User', new Schema
	name: String
	email: String
	dosesets: String
	active: Boolean