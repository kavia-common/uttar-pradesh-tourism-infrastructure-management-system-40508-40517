-- Initialize core tables if infrastructure_database migrations are not present.
create table if not exists users (
    id bigserial primary key,
    username varchar(80) not null unique,
    password_hash varchar(255) not null,
    email varchar(160) not null unique,
    created_at timestamp not null default now(),
    updated_at timestamp
);

create table if not exists user_roles (
    user_id bigint not null references users(id) on delete cascade,
    role varchar(32) not null,
    primary key (user_id, role)
);
