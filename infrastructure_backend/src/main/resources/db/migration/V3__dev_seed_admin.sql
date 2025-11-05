-- Seed a default admin in dev if none exists. Password is bcrypt for 'admin123' generated with cost 10.
-- NOTE: Replace in prod using proper user provisioning flow.
do $$
begin
    if not exists (select 1 from users) then
        insert into users (username, password_hash, email, created_at)
        values ('admin', '$2a$10$zYF9V1Aq5xwJZz2r7o6Q5.1iK7r8oYV0x8N3u9z3JvH0o3yq2j3Qy', 'admin@example.com', now());

        insert into user_roles (user_id, role)
        select id, 'ADMIN' from users where username = 'admin';
    end if;
end $$;
