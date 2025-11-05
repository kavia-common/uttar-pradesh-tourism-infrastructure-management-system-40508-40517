create table if not exists projects (
    id bigserial primary key,
    name varchar(180) not null,
    description varchar(1000),
    start_date timestamp,
    end_date timestamp,
    created_at timestamp not null default now(),
    updated_at timestamp
);
