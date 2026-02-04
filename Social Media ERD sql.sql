
CREATE TYPE "privacy_option_t" AS ENUM ('private', 'public');

CREATE TABLE IF NOT EXISTS "user" (
	"user_id" serial NOT NULL UNIQUE,
	"username" varchar2(225) NOT NULL UNIQUE,
	"email" varchar2(225) NOT NULL UNIQUE,
	"password" varchar2(225) NOT NULL,
	"profile_photo" blob,
	"created_at" TIMESTAMPTZ NOT NULL,
	"privacy_option" privacy_option_t NOT NULL,
	PRIMARY KEY("user_id")
);


CREATE TABLE IF NOT EXISTS "posts" (
	"post_id" serial NOT NULL UNIQUE,
	"content" blob NOT NULL,
	"user_id" int NOT NULL,
	"media" blob NOT NULL,
	"created_at" TIMESTAMPTZ,
	PRIMARY KEY("post_id")
);


CREATE TABLE IF NOT EXISTS "comments" (
	"comment_id" serial NOT NULL UNIQUE,
	"post_id" int NOT NULL,
	"user_id" int NOT NULL,
	"parent_comment_id" int,
	"text" varchar2(225) NOT NULL,
	"created_at" TIMESTAMPTZ,
	PRIMARY KEY("comment_id")
);


CREATE TYPE "liked_entity_t" AS ENUM ('group', 'post');

CREATE TABLE IF NOT EXISTS "likes" (
	"like_id" serial NOT NULL UNIQUE,
	"user_id" int,
	"liked_entity" liked_entity_t NOT NULL,
	"entity_id" int NOT NULL,
	"created_at" TIMESTAMPTZ NOT NULL,
	PRIMARY KEY("like_id")
);


CREATE TABLE IF NOT EXISTS "Follows" (
	"follower_id" serial NOT NULL UNIQUE,
	"following_id" int,
	"at_time" TIMESTAMPTZ,
	PRIMARY KEY("follower_id", "following_id")
);


CREATE TABLE IF NOT EXISTS "group" (
	"group_id" serial NOT NULL UNIQUE,
	"group_name" varchar2(225) NOT NULL,
	"description" varchar2(225),
	"created_at" TIMESTAMPTZ NOT NULL,
	PRIMARY KEY("group_id")
);


CREATE TABLE IF NOT EXISTS "group_members" (
	"group_id" int NOT NULL,
	"user_id" int NOT NULL,
	"joined_at" TIMESTAMPTZ,
	PRIMARY KEY("group_id", "user_id")
);


CREATE TYPE "target_audience_t" AS ENUM ('teens', 'adults', 'male', 'female');

CREATE TABLE IF NOT EXISTS "advertisement" (
	"advertisement_id" serial NOT NULL UNIQUE,
	"content" blob NOT NULL,
	"target_audience" target_audience_t,
	"budget" int NOT NULL,
	"created_at" TIMESTAMPTZ NOT NULL,
	PRIMARY KEY("advertisement_id")
);


CREATE TABLE IF NOT EXISTS "advertisement_stats" (
	"advertisement_id" serial NOT NULL UNIQUE,
	"clicks" int,
	"impressions" int,
	PRIMARY KEY("advertisement_id")
);


CREATE TYPE "status_t" AS ENUM ('sent', 'read');

CREATE TABLE IF NOT EXISTS "message " (
	"message _id" serial NOT NULL UNIQUE,
	"sender_id" int NOT NULL,
	"sent_to_id" int NOT NULL,
	"status" status_t NOT NULL,
	"created_at" TIMESTAMPTZ NOT NULL,
	PRIMARY KEY("message _id")
);


CREATE TABLE IF NOT EXISTS "event" (
	"event_id" serial NOT NULL UNIQUE,
	"created_by" int NOT NULL,
	"group_id" int,
	"event_name" varchar2(225) NOT NULL,
	"event_description" varchar2(225) NOT NULL,
	"created_at" TIMESTAMPTZ NOT NULL,
	PRIMARY KEY("event_id")
);


CREATE TYPE "response_t" AS ENUM ('yes', 'no');

CREATE TABLE IF NOT EXISTS "RSVP" (
	"event_id" serial NOT NULL UNIQUE,
	"user_id" int NOT NULL,
	"response" response_t NOT NULL,
	"created_at" TIMESTAMPTZ NOT NULL,
	PRIMARY KEY("event_id", "user_id")
);


ALTER TABLE "user"
ADD FOREIGN KEY("user_id") REFERENCES "posts"("user_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "posts"
ADD FOREIGN KEY("post_id") REFERENCES "comments"("post_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "user"
ADD FOREIGN KEY("user_id") REFERENCES "comments"("user_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "comments"
ADD FOREIGN KEY("comment_id") REFERENCES "comments"("parent_comment_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "user"
ADD FOREIGN KEY("user_id") REFERENCES "likes"("user_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "user"
ADD FOREIGN KEY("user_id") REFERENCES "Follows"("follower_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "user"
ADD FOREIGN KEY("user_id") REFERENCES "Follows"("following_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "group"
ADD FOREIGN KEY("group_id") REFERENCES "group_members"("group_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "group_members"
ADD FOREIGN KEY("user_id") REFERENCES "user"("user_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "advertisement"
ADD FOREIGN KEY("advertisement_id") REFERENCES "advertisement_stats"("advertisement_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "user"
ADD FOREIGN KEY("user_id") REFERENCES "message "("sender_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "user"
ADD FOREIGN KEY("user_id") REFERENCES "message "("sent_to_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "user"
ADD FOREIGN KEY("user_id") REFERENCES "event"("created_by")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "group"
ADD FOREIGN KEY("group_id") REFERENCES "event"("group_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "event"
ADD FOREIGN KEY("event_id") REFERENCES "RSVP"("event_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "user"
ADD FOREIGN KEY("user_id") REFERENCES "RSVP"("user_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;