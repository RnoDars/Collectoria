-- Seed de développement : état de possession initial
-- Source : Google Sheets MECCG (1661 cartes possédées sur 1679)
-- UserID : 00000000-0000-0000-0000-000000000001 (utilisateur de dev)
-- Idempotent : ON CONFLICT DO NOTHING

INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '001a499e-4e98-4371-9ef4-8ce2209bcfd2', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '003cbc0b-28a3-4d55-a440-07dbfbdfc935', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '00666e78-e4df-48b8-8a17-a41c3ed7e274', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0074a7aa-fdb4-44bf-a474-2f404881e859', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0108a4bc-7ce3-48d3-a05e-4fd54ed090ac', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '01341979-6268-4abe-a87b-301286eb61bb', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '014f66e2-6853-4f56-9117-8e96787ad994', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0161d087-18a2-4ea4-82d4-a687eaaf5536', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '01919f36-7389-4b7c-b13e-41b1e4b254d3', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '01e86fd1-67e9-416c-9e6a-2da3d04a53f0', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0294a035-da0b-4575-b023-5b879b9fce8b', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '029c3ea3-91c9-4431-9e75-9d99b2046375', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '02bafee8-a8a6-4fb6-a448-123f368b1b3b', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '02d49fe8-f09e-42fe-bc9e-0d1eae5796ca', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '02e9a5a7-e524-426b-9da4-736eb50987d6', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '02eaa499-344c-4b41-8ce3-9d9327c57c2a', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '031ca47b-90de-498e-a3aa-e864f9747d94', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '036f511e-78a4-4753-aaa7-3241ab5f0af5', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '037669fd-a6ee-4eb4-9349-f4bebcf94ef7', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '03932ce2-ae41-455b-8dcb-499be5f6445e', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '03bb746c-b79e-47cf-a7df-cf2eea349d13', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '03e8f05f-2a1e-4868-a3ef-0a54204d92b5', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0423c523-3050-41b2-b961-be1e3bcaccde', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '043deb82-a1cd-4b44-a9cb-26423e32a075', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '04aa3949-6b84-4b63-acad-7d62db5480a9', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '04b6bb25-0f99-4ffd-ace5-741d732d25f6', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '04e8d657-7a14-4416-8f44-ef829981f6d6', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '04ec516a-fc36-485a-b236-047f30dd4baf', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '04f89316-34bf-495c-b40e-2ca8785af8a0', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0501c196-a42c-4f10-a4c0-c2b8826f4d11', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '052f8be2-3d08-4f70-9a55-cd08bba33ab5', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0542571a-6639-4fc7-831b-d30fa3d4a12b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '057a4ad0-d184-4d36-be4d-a1aa2ccd081b', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '059aeaa2-f72a-4968-a627-73b20c2d7970', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '059da250-3d6f-44f1-acdf-ceca98e01a64', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0600abc3-75a8-43a9-85b1-6bfde137072a', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '061ec834-ebb6-4923-ba40-2e7d5dafbcc0', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0632aa3b-24ef-44be-a99a-fb5175a11e86', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '06703c8f-78b1-4a27-9d5e-4551b39458be', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '068c0ba4-aba5-4538-8568-6f5a7d0c9847', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '071e1cab-84d1-4db8-9b26-29ce6f493273', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '07269ec3-8930-4867-bb67-a99658f0db38', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '072b68f0-bda1-46ce-9df4-58b6d9244486', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '07561bf1-48e3-4a21-9724-14e55575a264', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '07b31b0a-89fa-492b-abd2-a28b7e79b979', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '07cb12d6-d6d7-4349-ab96-9b9320f8c9f8', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '07d80559-d23c-41db-90b4-484b54266261', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '07f67f96-5335-4748-bb91-8b17dfba026e', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '082442a8-ea92-48aa-9c31-fb9146563ca2', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0854707b-f2cb-4a83-8283-14842609533c', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '08a8edc8-c061-4389-ba95-30d485721fad', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '08cdf0eb-dded-44a3-b20a-83fd3bf9bd16', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '08dbfc22-87e7-4945-a9ae-5b15b9281ea0', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '09250388-6768-4095-8bc7-956bc9232aa6', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0931ad8a-4425-40a8-be2e-23eb2e93e492', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0961d5f8-4d0e-4ca5-a547-84a4d725d0ad', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '098d2ba1-7663-4b95-82d2-388cd71da68a', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '09c9d77e-fcc2-4f5b-8e9a-55cf248d80e0', false, NULL, NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '09fdb0b1-d4e3-48bf-be08-6b5ca0c47cdf', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0a5b3acf-49eb-429d-b050-d19306d68658', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0a7ce4e3-b5a8-4b6b-9aaf-3382c3a7e181', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0a9f4561-5d66-4dd5-8d47-8a12ef66c393', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0aaaf26e-95e6-4874-b571-f7a3b4add18c', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0ab7f369-d47a-43f3-b1a5-150410ee65f2', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0abf4508-47ce-47f7-83bc-a7fad0450c7d', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0af0272f-9fed-4dec-9ff4-e7e4950b0b48', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0af9c845-40f0-4459-88e2-8b92053491d6', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0afb3818-90b6-4c68-8886-e455e238751b', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0b8bc7b1-39f0-475e-805b-162a5314e0d7', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0baf0827-ad1d-45fb-a549-bf1e8f6638ce', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0bdf393b-1076-4ea4-a3d4-10aa171c724c', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0be0b1af-3c4f-48a6-88af-bd96e62392fb', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0be5f835-e9b4-4c88-8b65-c6a7fa5567f2', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0c00519b-bdca-4e09-b67c-8a9afcf7678b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0c3e07f4-e997-4b21-9ef3-413948b82cc0', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0c433d57-f4aa-48de-b720-22f597823d6b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0c72c473-9db8-4ee1-8b10-604a5ce16e18', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0c7d1b37-ccc8-4b44-a2b0-3132292c09af', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0ce72a63-d441-4568-b13b-1816b54b6600', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0d03d96d-9d96-41d2-bfdf-5ec37a3a060f', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0d11c23b-255e-499f-a453-c7404d15e063', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0d242b5b-48a9-445f-bb28-46e7cc41bd0a', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0d4bcc18-e331-47d9-9c91-48187eaacff3', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0d54338f-76e9-4387-bdb1-73867bd33721', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0d61a05b-a1ff-497e-bb4e-54d48c9ed791', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0d633aaf-d5e2-45bb-9d17-473c4d810700', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0d761b27-c522-40ea-a573-c99919514ebc', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0d804011-830e-473b-ad02-b36be1166e40', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0d8fa3b2-8356-4c74-b159-4970a5f9af7e', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0dabaf86-3045-4478-9fbb-491c349fa8ac', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0db32d2a-1c2e-48af-b188-a3fe89d687d3', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0db682a0-ee43-4a72-b4f3-40e90264f497', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0dd5f76b-592f-49dd-8949-5f88b67f8638', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0e17231c-52b1-4f69-a802-d6a8ceccec46', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0e19cf41-6220-4292-9925-0d14cae5019e', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0e1e70a2-e9f9-4d1a-9dcd-264ed6c65f20', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0e4cf34f-bdb0-4961-9da6-5fbe304b1260', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0e9238db-493e-469a-a263-75f12c113afd', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0e93b062-8445-4d0d-845d-9498341b0c60', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0ec20974-d87b-4620-9eb0-65cafed062e8', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0ec3f5f6-2056-4330-8176-e58bcc1e1f55', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0eecb689-ec2c-4b6c-ba78-9e2c72cc7e89', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0ef9cf9c-aca4-4f00-b288-4e42a2ba20d8', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0f333b27-d984-422a-a623-4c797afb5628', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0f3dd04b-b0a2-4cef-8957-2040a53b963c', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0f6e53f9-896c-4ce1-b6ba-7eb52cc9701b', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0f81e0e1-5cec-453e-bd3a-e2901bb6e721', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0fa541fc-2d25-4f04-862e-3faba76086a0', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0fea325f-f388-4c2e-9839-c22e9530bd80', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '0febe64b-4887-4fc2-b4c4-962ee63e274c', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '103e1501-04c1-4b48-b305-e0a0daee2a31', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '108617e3-a5de-4d61-aa77-07626ce747e5', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '109c8646-2ad4-4df7-9485-ee4596277e6e', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '110592ea-dfa3-4e44-99f7-b63ccd284708', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '114a7cc9-27f3-4c82-ae87-def1c4324c07', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '11653042-76fe-46cc-962f-7649fad532a6', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '117e68b5-15d2-4e94-bfce-1a2221eb371c', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '118744c9-e6f8-4c1d-a88d-565d9d7b6738', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '11ac0fe4-4b2f-4687-86ca-6e8c04fd91b5', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '11cd39dd-c09c-44f0-8a29-b6a2ac404919', false, NULL, NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '11df0994-2e0f-4bba-86ed-8bb74d99667b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '11fd9bec-9f29-4b56-98c3-24daf1dfb908', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1210fbe0-498b-4633-bc98-bc6112d5020e', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '121dcc51-54d0-442f-8e7f-c827b6b9eeca', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1223846a-2a1e-4239-9c1a-e194a557905f', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1225ff0e-7398-4250-b2b2-e473d63676b5', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '122c0106-926b-4f56-ae8a-302d3127634f', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '12300f03-ff35-4925-8894-9edc7177c0ee', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '12496d14-f291-4a01-a6f4-638a0d9c69c1', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '129bde00-4f26-41ce-b2e4-ee513afa0432', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '12a506f0-4d9f-4c2f-9a36-809534ffab7c', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1332195e-11fb-40fd-9b3e-1a15cc1eb36a', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '13370465-2f5a-46e8-a58e-082a8aa40610', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '135a5872-4eaf-4e68-9a95-36f5e9a68da6', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '135d4449-974c-4740-9025-01f33ee7e251', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1371512f-b85a-464a-b682-211f38926eab', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '13a04c51-2937-44ab-9356-7c694d46fa87', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '13a43332-19b6-4d11-8ca0-f022cb5ca5ba', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '13b3907b-d9b0-4b0d-8908-82a844e89eb9', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '13d6c183-d27c-4882-8322-ea0050d1192e', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '13dd4a91-b48c-43ef-ad2b-5f5500e2662b', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '141331a7-a36b-49f2-8cd1-a46ec17f7ccb', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '14217d50-42b8-414b-96cd-2d9c52017060', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '14b29d69-4cb6-42b9-9ba1-4fa25eb1df18', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '14eabb6a-3114-4be8-b0a8-1143a0189836', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '150532c7-618c-45c9-9698-eb1603dd454f', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '151e4141-8519-4f0b-8670-eae5c6c13a18', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1547ef3b-6c34-4f3a-ba48-12b0693d27a2', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '154e5413-b298-476b-bf7e-b350abb745bf', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '15769042-d2e2-42df-bea1-16b265b4233d', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1589f8f6-bbfd-410f-81d1-18cbb63eebe7', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '158b86ac-17fe-4abe-a9be-4ef5310bf5f5', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '15d3de3c-0dea-48d9-8dcd-c6fb5ae2301b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1600fff1-4467-46ed-94b9-91bacfe4a774', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '16075af5-100f-40d9-832b-2ea8ac1cacdd', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '16846e8a-2861-49ed-b44c-134776927aa8', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '168be65f-1ee7-4ce8-b471-ce2971c7b645', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '16b08a44-3763-4fe0-baa1-201ceb92be49', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '16b7e1d1-c622-4303-8693-d018e6e75afc', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '17185277-cdee-48fc-b954-880354b2f09d', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '175b0783-8d79-40d2-91fc-7371e3daa1ca', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '175c1af2-96a1-4a87-8b28-98eee6384f0c', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '17833ed1-dbf7-4611-8817-347ce41c3e9a', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '17b4eccb-32c6-4147-9319-4322771e8904', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '17e633b1-0ea6-4961-93ba-660ee472b5e1', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1873c4c0-38c0-42ce-80d9-204c130ea1db', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '18b719af-c949-42ec-bb33-ddc339910bd9', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '18c33b2c-16e1-48a4-8558-71bb9c0293bd', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '19452400-a83c-43d8-a39c-d50755941eff', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '194c05c4-a1b5-475b-83b9-e39bcb2f3961', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1959f275-a0fc-4b2d-b690-0d238f04f044', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '198e31e7-c85c-4ba8-9036-39089b6f5f7e', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '19c4581c-3f1a-4655-9810-9e159dc59b51', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '19c98257-c759-43a4-b831-d289ed760d7b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1a4e31cc-0b45-4ab3-bfe3-e3a199afcb29', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1a73c7ab-e4a4-4bc9-84ef-a527e107f68d', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1ab0acb0-553d-4f2f-a222-7ebd59297b33', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1aba34d8-3aba-4ee1-a5de-33186a80c204', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1ade1f40-e87c-46f5-819e-9c49a9d7a2b0', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1aefea56-0599-421c-9274-38fbfb725ee3', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1af90240-cab7-40a5-a1a3-8d864f2aac3d', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1b0c963b-f689-421b-8639-d8c89bba9cca', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1b12a23e-2992-4ec1-88a0-4e8333ca2d24', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1b1551a1-7cd3-4572-8f2c-ca99d9ea5dbb', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1b659eb7-86b0-417c-b386-2e63ef5abcbd', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1b79437b-065b-4816-b1a4-d347394b8416', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1b86ed76-f043-4445-9ef4-d38b51ae1652', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1b92f80c-bc49-4fa0-b1a6-4e7361a2500b', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1be8085f-0a54-4bb2-a3d2-8681203b1ef9', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1c3a4dc1-fb0d-44be-8cdb-a29870d07eef', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1c3e6994-a909-4b22-8f65-216902359556', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1c52e93a-860b-4f02-97f8-006c0a5ed6a3', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1c56fd9a-a05d-4a6a-ba1b-48748193c690', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1c58884d-2ac0-4e41-8e22-9a3fd69752d4', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1c696824-d4d9-46d7-acaf-9128bfe5c256', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1c6da0ff-67ec-4043-88a1-fb600e83980c', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1c8c0d2a-b29d-486e-8191-b3489a8116af', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1ce1bd58-0852-496c-bd16-02a4afe425c0', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1cee503d-4c5b-40e2-91ae-4e916844b7f8', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1d072ade-98c5-43cd-9477-2c49dca395da', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1d19f3d5-d3d7-4ad8-9b10-5629ddd3dcd1', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1d416377-293b-489c-8f01-010b5f70a137', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1d42f1f7-ba2e-4917-9335-e147bece74fb', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1d503979-c2f7-4dd5-9505-657e416c2d69', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1d62f518-8aa5-4068-8141-f14b53858e58', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1d744d84-f0a2-49c4-92cc-a7a192d5849d', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1d7ce4dc-4987-4841-ba77-0d5cfd0b46d7', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1dc9ff24-9491-4580-a330-8bfb32bae69c', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1df01d98-655c-4641-b0d3-19eb3055a255', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1e173c35-ad53-4d0d-a9a6-fe1f633a62c9', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1e6530c0-d1e1-43a3-80ef-4750436bb1b5', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1e6ea909-3234-43ec-9d89-57d4eafc1ed3', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1e8465f4-e09a-41ba-9efd-9f2f761ce1e4', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1e9a8e3d-951b-40a3-8e57-5be7ddc287be', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1ee8a1dc-8ebc-412f-a9cb-221c81d0eef6', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1f0bfa98-6306-41e9-a6ea-05f9ab5c1dec', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1f15d625-68b2-47f2-a497-6cb793abdee6', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1f23575a-bcaa-4013-9fdc-8a1999b4965a', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1f47165d-2dc0-4997-a418-2e3d554a6483', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1f4c33c8-b51e-4e4a-9e26-132042f9a390', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '1fba650a-05ef-41fd-9ba9-483b8b53d6ff', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '200052bd-f56b-4f2c-ad60-e7c882417714', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2003943d-17c6-4ecb-a693-a7817d58dbe0', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2010008b-9a7b-44a0-8bfb-377be774df0f', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '207b67a0-043a-47f5-8daf-32beaa94bd42', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2085ee67-b9dd-4f69-95c9-b532f2e0b9ba', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '20897872-1735-4672-a088-e455410052e1', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '20990f1f-4f1d-4ab9-95c8-3002ee15bbfb', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '20a1bdc3-83c7-4f9a-be57-fd15d6b850f8', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '20a96657-b670-4873-82c7-58e0c2c9dceb', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '20c17993-db51-4e85-aa2a-1b0d9ee48e74', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '20f3f2c3-07ca-4319-8df6-f62d1d5b193e', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2115077a-8dd4-44b2-9864-5567c577d90d', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '21495caf-282b-41dc-a647-8acba9084204', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '218bcd13-668d-4810-9efc-97b49756cf16', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '21a05bdc-212d-453b-90e7-f16303141173', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '21bcb067-55b3-485b-b2c1-d22e0979947b', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '21db4383-8776-4055-bb39-a4ab35463378', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '21fc53b7-d471-403b-9e12-5a986c04ba8e', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '22102baf-853e-45a1-9653-9e67eba04ed4', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2220758f-d831-4af4-ad51-7ce1f7c35842', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '224b5fd0-758f-45a6-9282-9423b0065978', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '22c2ef8a-fc52-4160-8f5e-09ac4268e137', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '22db100e-572b-400d-8adb-167da203d682', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '22e88250-8db6-44d3-87c3-22212fec1a68', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '233e8b44-895d-4fce-b2d9-008e87e70d93', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '236bce4d-9e37-4f6b-869b-839411637d30', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '236e9230-c2ae-442e-92ad-00ef23547419', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '237d3258-b738-4110-af72-fdf4f7b42522', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '23b05d88-cd55-4cef-a18a-0f69eb57caec', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '23d54f41-9975-4b61-b490-db453148e5a8', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '23defb2b-7962-465e-abc5-4d264e2d4e25', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '23ecb7f6-0e6c-4a2f-90c4-162916b5e512', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '249a2b1f-7e77-48d7-82e0-45f1cf8699a3', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '24c03cf5-1530-49da-8ab3-ea33d344912f', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '24c1fb5f-34d1-4693-872c-97e3167016ec', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '24c76729-9530-45c7-847d-3f1bc41bb26d', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '24cb9b8b-a7ea-48ab-ba97-af38e780c659', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '24efaf3e-7c94-41c8-af51-45a27084b595', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2503e26c-636d-4608-b2b1-251c05774ea4', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '252d91bf-12bc-4108-a395-a7c8f1151894', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2544ff93-add2-4024-a519-13bfffc2f52b', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '256159ef-5e48-4ed1-a966-6971660a223e', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '256dbae7-8bb1-4619-9acd-7fe455df3204', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '257ea911-cee6-4323-89f5-016e8770b5c8', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '25d0a609-0f4d-4e9f-94c5-5e11a72a1ae5', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '25fde918-dd13-4e6d-8dc9-49743fc69ab1', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2620c9fd-e349-49ab-b517-6b88f47b2ba5', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '26509664-af57-49b5-b89c-c6a40c5cc5c1', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '272e7cbe-2da6-4f1f-9a70-fa6530aee8b5', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2740d57c-df01-4df0-8255-77c4a30d371c', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '27467367-c9e7-465b-911c-31ff1263edff', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '278f0364-c73e-49e2-b96a-c70adaeb5d07', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '27d901bc-228f-4276-a7a5-72c5e5667cb8', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2824c1d7-135d-4547-a6d2-3ea7d7647895', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '28382186-e938-4876-be96-4b226acd9270', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2861da6d-f986-46e9-97bd-cb85b4f85de1', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '288c46f5-a32d-4216-950c-584ed7f08072', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '28b072f2-2e06-4203-b2a9-9a24552f6788', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '28b9d43f-5c65-4b1c-9675-8ed207464bec', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '28ca3017-3fce-4117-bb38-23339d40ce38', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2943ad7f-a5b5-4972-bac4-cf8641ec9076', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2948d693-9c6b-4145-a27d-18089d339eb4', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2a0eb3f4-f8a0-4f3d-a9b4-3c1d65fd4af2', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2a32a854-3ada-4ce8-bf3e-3eb6e9f09c65', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2a8d6c39-56e9-4739-928c-8cf18a2128ff', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2aba5f79-429e-4668-947d-6fee6a8ed0b8', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2ad2d07f-fd33-438b-a08d-2e7db3f258ba', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2b094c6a-d791-4f9a-8d35-ef93940c826b', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2b373e99-468d-4fb7-b8a9-268116440bee', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2b69239a-24bc-42de-90df-a528d8c5e851', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2b9e9e0b-70dd-4428-a0df-b79e41bc59b1', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2baea4c2-84f3-4a3b-82f0-c937604a6c34', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2bb2df61-c6cd-4fa0-83df-fa98e771990f', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2bc84489-d3b7-4b1b-8761-544653444409', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2c4f3eab-bbf5-4545-8613-58341cb91abc', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2c55735a-fb40-4cef-868e-6d9b9916efac', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2c9d0929-e324-4498-8c86-af754960ae4f', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2ca49639-b1b1-400e-bfa9-cf651be585be', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2cca17c9-fc6b-4ec3-b823-64fd8c6c2ea4', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2ccdbd95-202a-4437-b2c3-36e6b619e448', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2d41f969-1959-40d4-b100-084126ba0634', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2d53c4d2-2279-4cd4-b8fe-c1fa270ac509', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2d6d2112-8f12-4966-9318-2b709b1e981d', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2d6e73e3-5712-49da-b179-7787270c28df', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2df1ae32-c1f2-4833-9663-e72ac24a298e', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2dff3fbb-de67-4adc-8d81-7e7879c90675', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2e100318-753f-4d4e-bc95-4f2d5ed4c0e9', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2e8a6bca-42a3-4f4a-bfda-c97984b8068a', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2e96173e-d1e5-4ce2-be19-f5b31fc416be', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2ea07911-3e36-4787-ac10-4506ccad1311', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2eca10c0-397e-4576-85f3-09c89a020c64', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2ee4fa73-204f-4239-87d3-dc835b1e4d90', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2f10634c-572a-4a9c-9f83-f34318540b71', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2f14d304-a2ac-4414-8e76-1e39a6739da0', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2f23d50b-f31e-428c-bf3f-29d42e471a73', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2f5eb9b0-ce11-458d-af4d-b50609fa0184', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2fc8e429-2810-40ac-9ac8-7a0992b1edb8', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '2ffce04e-a420-4036-90d9-81f89502cef6', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '30185e20-becd-4ca9-9c89-a2d3dbc5168d', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '30370a19-52a3-443c-a835-ef651d9edb44', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '307e1c63-6860-4cb5-9d18-21250290f53e', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '30a03da8-6752-46b6-ad86-b5b94610c012', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '30daed50-2da2-4bcf-b234-48082b1941cd', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '30f1fc7e-0caa-4fb0-9d6e-e8e61e69b978', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '30fa2ab8-a230-4b2d-842f-479c3e9dde7b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '31270635-4703-4668-8b26-f0095b8c37a4', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '31a25411-f574-484c-9413-53abee0cf951', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '31a9fb0d-8bca-4f97-88b6-d841fb1ba763', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '31e9a393-fee1-4a7a-acff-de1cc91b5784', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '32054787-3e8f-485f-9d4e-1ca72f15fb8e', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '321d5080-335d-41c9-9b19-e55315056439', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '32475c10-c9ee-4746-b066-096872ecbd46', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '32694931-add2-4aa1-85f1-0272d4452eab', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '32867967-b62f-449b-a339-e9b993895b9f', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '32d4371d-c791-41e7-ba53-9f3ec5c190b9', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '332fe07d-c795-4e13-8f8d-560975b14b18', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '333aff36-fb4b-4400-a9ae-8aee1d7ea2af', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '33775080-2fb1-4fc4-8a35-79a48974a76f', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '338369bc-6f4a-4dd0-bfdf-8ef0e46f385f', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3393758a-c0ba-4a1a-97a7-c655ef840811', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '33e59571-36ed-413a-a66e-154a194e4e8a', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '33e66516-30f0-4470-87c3-3175f6974375', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3441da3f-38df-4ea2-8b4b-b4f07b1806ac', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '34a5a3c6-7c4a-4d2a-8988-d94e61c40c20', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '34be2633-c3ed-484c-80d4-2142c1424462', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '34c47f1b-944e-4e74-8fa8-97b0ea0ca5b8', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '34ca8f7a-c306-49db-ba39-745f2dd526c7', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3515a432-5302-4239-880c-aaf81c8dcc8f', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '35335371-21c5-4b35-b0c5-ae625e264960', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '354f74ae-7ae8-4773-b754-555718a85e4e', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '355f493d-e4f3-4f13-a2e1-0712c8696023', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3600f591-b138-4657-8889-1cad226eff23', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '36255428-13ff-46b2-83cb-f53c40bd9245', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3657e409-f5e4-4175-b4bb-613ab40c6def', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3672689c-d672-4a40-9734-3b1281acf379', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '36c3b87c-ac89-4e8c-b3b9-b5b25f534e3c', false, NULL, NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '36cf8af9-d9d0-4480-9e3d-7a9c5144095a', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '36d583c2-55cd-4b46-91fc-584b60e64d0d', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '36da70d4-d403-4782-92da-6c6fa3ad1c6c', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '37123cf2-19f0-4e3f-8bb9-c70b46959ec6', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '371418bc-fa18-4671-930e-944fc3d5c5d6', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3729f918-a25e-4386-ab35-58fe41eba912', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3749e8bb-f945-42e9-bc50-5560e7c032af', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '37c1fb15-f646-47e1-9178-816c1ffa309a', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '37c6a770-2fe0-4b68-a2a6-763f8130cf7b', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '38173f90-2e15-4d21-969c-c162484d34dd', false, NULL, NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '382eb86d-5925-4e05-9c43-b7c2acbf6408', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '383a7e0f-fdc0-48f4-b42e-63cf45b16c33', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '38a9387c-f94b-4c0c-a0eb-ae9526bfea0a', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '38b6bc6e-e884-49f8-93ae-6da9d09ce2e2', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '396f8e98-8a69-4686-9f56-bbafdb8ad4d9', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3982fd31-b8ff-4d05-9bce-6e4708dfa21b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '398c16ef-d152-4698-8824-3b4c8a6db70e', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3991c37d-fa8d-486e-b1ed-5585d92dbccf', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '39b74425-0cd1-430d-92b2-ac7bc19c8dad', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '39ba69b6-6eed-4f1c-9ec0-d19580f692e0', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '39e792c1-3880-42e5-af8e-3458ef5014f3', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3a3a799c-1d5d-488b-a3a7-ac377eafad32', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3a4d57a6-f47e-415f-bb58-25cd7e5c362c', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3a569400-3c18-45eb-bd7f-0af10bb4c927', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3a80949c-aa2e-4904-91bb-f997d53c4418', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3af31b7f-7fd3-4a0a-b963-cd92915d10fb', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3b29c582-f691-4292-a234-6bedbce08a70', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3b3b26e0-1837-446e-8d72-76c135ceaa89', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3b476dba-1021-4a80-ae6f-260f626eb163', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3b51d534-ff25-4de2-804b-ee75bb0cea04', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3b6fb4e2-2fe0-48b6-a66b-27819804a146', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3b8b7b05-5ce8-4eaa-a7e6-8324bb2b7e4f', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3b9359e9-ef8b-480c-a47a-abbec47fa57d', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3c2326c5-dd5c-4edd-8bfa-1c18458a337b', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3c2f73a9-60e4-4c96-8513-623c1ada639d', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3c4363aa-6945-43d6-b516-d4e6cfa12dd4', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3c5e7434-0213-4cb3-bbef-d1d82b978ab3', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3c7c0824-4f65-46a8-8e5f-a8943bcfc3ff', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3cff9432-d71f-404b-94ac-3b35deb212b7', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3d217259-0185-44df-bbea-80426ccda2bc', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3d228cd8-3c5a-4b52-82f0-22ab4a171f04', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3d423844-2355-4a04-aa73-34b2aaef9c35', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3d941aa8-6715-49f2-9707-e76dec0439f0', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3dca5ba6-5194-49d4-b5a7-3ef57b76f665', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3de46a8a-0a95-4f75-850a-e74743d12197', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3e00d681-651c-4505-b960-82767f655fd4', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3e16f208-1061-4d97-89ca-68a039d5947f', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3e2328a2-475c-4ff2-80ba-899a2ea4570d', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3e9461f2-8b08-4751-9b5a-c7a8c7b82529', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3ebcd33a-60b3-4241-8cd9-84a70ddd84ae', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3ec97e62-8ea4-4f3d-a91a-4310b1f6205d', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3eef66ff-80a4-4854-bb2d-0d28c4c0e71d', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3f2cb56f-d316-4be1-8eef-253f3682a047', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3f34b89e-77e4-4474-a340-226ab2a97ee3', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3f580906-3e4e-4d4b-8d77-8ae8193f0887', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3f5a2e84-3c35-43d1-a154-922089a3db55', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3f5f5b15-c753-495f-aea6-b779f759d929', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3f7fc716-0f25-4bbf-8df8-08b1e94a17e0', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3f8ab5f8-8cdf-4238-a2b8-bd66df5fec61', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3f9bbc86-3dc6-455f-bba9-8f8e0b4c2860', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3fac3478-dfb0-47e2-9312-6ee36a2b9575', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3fb9e2df-d062-4105-bf79-df734549d3f6', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3fc64cd4-7dbc-4c51-98b6-10900e9c7def', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3fd3c876-0258-48aa-aa36-abc910f1e68a', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3fd6bbed-0c6e-4cd3-8219-b0a117eb6a2e', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '3fe494fd-a198-49b5-946f-e9f3ceaa51ed', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '403dc833-565c-4d9c-ab2d-1630926ee014', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '40bd12fa-1057-44b6-9851-ee73d4f81bf4', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '40cca7c3-146d-429b-af53-35b7319d547a', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '416716f5-5a7f-403b-afaa-c451cae4c217', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '416e0e95-8bc0-40bd-a02b-3eb0ced5cdb5', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '41a0534b-a645-4b58-a551-5c020e1d37f2', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '41a57199-8c08-40cb-b21a-3a3c4cb4b207', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '41b4af03-6102-4f64-9441-10332f97b3f2', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '41b62cea-d572-4faf-83d5-7fa27a570de1', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '41e79e1f-4e94-44cb-8009-0aa412774095', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '41fddd82-71db-48a4-8b6b-65c96442dd0a', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '421f0f54-db99-44f4-8ef1-942ed97fe200', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4225e368-9365-43c8-b189-9cb889dca4b6', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '42720ad7-c94e-4cd7-a31c-a1a39f77ca9e', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '428bf153-3be8-4147-a9bb-3c054c91a06b', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '42e0df19-dcb1-4032-960e-b5a18ea7d128', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '43115d7a-a628-44d6-8620-6b53a9cfc9df', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '432008e9-b830-4653-bcd4-cef3a7e0f7f6', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4333386a-f8a1-4727-9707-863362c7992b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '43385e09-7d3d-4a8d-9b0d-574a2d70819c', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '433df9f3-4a7e-4bd8-8356-0926b92b4893', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '43527761-a784-4117-83ba-859b2e679679', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '43627ebe-d2d5-46f3-8866-6766e4467a3d', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '438e68cf-1830-40f9-81ff-b77735879e2d', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '438f5fb5-1e59-47be-845a-73496fdf93c9', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '43a9d700-56e0-458f-a691-ff65456f68af', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '43b4ef6e-0758-4e1e-81a8-4521102c8f16', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '43cc3b82-e012-4df5-a872-84aa51057a95', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4407c7f7-04c3-4876-954c-a389cd63b2c7', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4419d468-7267-4162-9776-e7235a225038', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '442241c7-9b26-4088-a245-0461d16819ea', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '443ba6e1-22be-460c-8394-bc99fd1dd648', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '44465599-b4b3-4bc5-a542-0b2fec7e301f', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4486ffe4-7381-4e8f-9789-cb7573607b03', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '44fd8926-657d-41a9-b5c7-255095066393', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '45c88f3a-197b-40db-a0ec-ef3c0f10942b', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4602261e-d93e-42cd-ade9-a9479ac1f216', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '460dd968-966b-4102-89ef-26040eef7ba0', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '46af7b3f-e2be-4101-afb4-bc2ccf6cebb2', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4711eec9-8971-4235-a774-edbbdb9086e5', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '47eb4f8c-3e33-4c28-ab8c-d80581431c00', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '47f20bfa-583f-47bb-8470-6085bf32c089', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '47f4e3bd-f32f-45ee-8b7c-d4bb0c05260f', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4803fda2-5a60-495c-976f-716718a7a361', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '48269002-dbfa-431d-bc86-42451e6c7c54', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '48499af1-a2ca-4af6-9545-ccb49e8c46e0', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '484f903f-7aa1-4002-addc-c6a3d60713ed', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '48766a23-d5b3-4d20-b6b8-879f28f1fde0', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '48bbfcd5-a72c-4f44-bc52-2e4bc49bda7d', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '48e2b309-447c-4886-a359-1ba22070e971', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '48fe38ce-0508-470a-ae7b-e8f82bd54590', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '49056f32-38c6-4fea-8d56-8087d1335414', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '49568b94-b1cf-4e6e-8023-d697684d8767', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '496930c2-1d62-43e0-9f51-37a112ecae08', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4997d566-f7db-428b-983b-081facb7e061', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '49b2da78-79ab-46f5-9c41-dade0280671f', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '49b4e8c6-e135-4f0e-bd6b-bf4f9090033d', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '49c74fe9-c704-4021-a173-c62eec767398', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '49d468de-c709-4a03-8072-bd3b25e166d3', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '49f69ce2-64f7-4883-9134-b2886e8bfeb2', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4a269f10-3fe2-4126-8455-2588aebaf8b9', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4a44b47e-21c8-429b-9acc-e41ff4fe1abe', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4a47b51c-257f-4e6e-b381-95251ed4d02a', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4aab29ce-6fd0-4671-a016-9a38afa78e40', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4ab8ef56-01eb-49f7-a4f2-4448a8c7d6fc', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4b10842f-a062-4835-8fc4-ff34d3b27f75', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4b159d6b-dc02-4163-adaf-d5d60de27d40', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4b2dc53d-70e6-477a-b9d8-90a77e179ebe', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4b3d2199-0d9d-4d96-a882-2bcee50ce1bd', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4b7b2476-787d-4233-bb55-1f6364cf8e75', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4b93f7e7-86f2-4a2c-93a0-daae488a3e22', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4bbcf2a7-d76e-49fb-9048-28c67462186e', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4bcb1495-ea22-4190-8e8d-2695243f2f5b', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4bcca42f-a1cf-455a-b761-5b97e5be794a', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4be1e1ab-cd1e-44a8-b908-5447cdee2ed7', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4bf4ba9c-aeeb-4d72-8d88-a5dc81fa2e17', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4c456292-3a44-46f1-b087-73433566ce5b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4c77c5f5-8317-4a53-908f-8cf808a1a600', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4c86487e-0ed7-401e-b555-a9e4f6157479', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4cbfab52-c23e-4a11-bab4-514690cc0c89', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4ceb96d5-c667-4cd5-a1bf-910a34042049', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4d0401da-3b6f-43bb-994a-89e77737e920', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4d45f5ac-1788-4c79-9e1a-471c75909aa7', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4d571b28-54a5-42fe-82fd-7ea606b21412', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4d787c30-c97f-4079-9045-fbf3fa9bba07', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4d80cdd1-0eac-4c9e-98b5-9c35d9c164e4', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4d88f4b5-c82a-4349-bc77-675b93eb1de3', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4dc06139-079b-4a7e-878f-4f1d61f95b21', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4dc0e359-8c2d-4750-b7d0-032a54a07dc0', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4dd86cd4-ec38-4ffe-bdbb-f735e891d2a1', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4ddd0830-d0be-4511-bf9f-3874018530b2', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4de29039-53ee-43b0-9543-e8b2db018680', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4de9a035-efce-4689-9dc8-f8c2cffa3ae6', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4def6acc-2cdb-4327-8f77-dfb31ab8917d', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4e012846-c19f-468a-8345-5e3e42c91d20', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4e05d080-619b-435b-9baf-4591cf7076b9', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4e2991fb-f374-4941-8bda-5b6083dfd1d6', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4e4e0faf-0d91-4c1c-837b-6cffa005670b', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4e7ea758-4641-4a11-8d08-61eff56a6596', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4f0c649d-ba9f-414f-b81d-f993810f152a', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4f1f2942-4d24-440d-abcf-6ca73daa1941', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4f4d0156-bc6a-4e3c-82b7-5a9661d54108', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4f61db06-1560-421d-8f13-5336bb1ba3d1', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4f6ea22e-40ae-49d1-9308-dcba5c6a1e86', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '4ff28926-ed8f-4f2b-8047-a71d25e47301', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '50064d9e-635a-4c9a-83e5-3bbb9248f6a6', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '500d2f4c-ee9d-464b-859b-142e586cc1e6', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '50613689-ecca-49cb-be60-410c1fb8335f', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '506ab2f0-db4f-40af-832e-bd1da9599d95', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '50cba68b-fd54-42c7-93cd-0188728a4ada', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '50ce3f8b-e7d9-49ad-92f5-f06f058ce7bc', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '50d07caf-79bd-4c9b-bbea-2c3610a3acbe', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '50efda4b-8ec6-4a5e-b548-89574ad22613', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '50f42c1d-d820-4ef4-9c16-d7d2ae093a44', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5117d3e8-2724-4fd2-8bcd-8264f229efb1', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5128e57c-73ea-4766-a434-e055e55c9469', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '51462a8c-52ec-4075-842e-615c3d563f98', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5156e593-72eb-4157-a10b-5374a8d02d2c', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5189ebb5-cae9-4c70-9aca-78ccedf6f734', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '518d660d-ad52-481e-8cd9-a4962f6d8aed', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '51bf0e77-72dc-4566-b6d3-cfdcdd7c4acd', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '520f16a0-7f66-42e4-9842-06f7c2a4e3c6', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '521f0d30-2b92-455b-b735-a9440709903e', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '521fcf3c-61b9-41cc-bf9f-8b9da910eb57', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '524205f2-f1a7-4521-b21b-8958bed6d877', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5266071a-ab5b-46ee-af99-5c4f189647be', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '532b6718-c51f-436a-8c83-08e2a7dc3912', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '53370fa1-39c4-4bfa-a253-e4b125e7e5be', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '53715fee-2e0a-4df7-9e41-024341d80ba6', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5376a295-f4bb-4e27-a615-e21a99985c69', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '537be06a-58ce-4798-9d70-1af316d0a565', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '53995def-d5b6-4aa3-9e51-4b7d3eeb5fe7', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '53dd6bd3-dd85-4c38-95d9-bad7dd686086', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '53f50929-4645-44d3-a605-78aa137906e4', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5430565c-3dfa-4080-839a-35c7e50cc1ea', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5437ab31-49e5-4bf8-b2e7-93b5b9647b44', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5445262a-df40-4017-9760-34ea326d1a92', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '546eaf50-4410-4502-909e-04d823075f64', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '54a9e8f8-cf58-44ea-babe-a42751fc854e', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '54f2ee48-c5c0-4e05-924f-ed63f95cd097', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '54f3c7fd-e7bc-4e3f-bf34-96e4349883a3', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '54fb5d54-7d6b-4059-a811-67b75b8f5178', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5529d493-9202-4423-94fc-13d5610f2196', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '552b91a5-6f13-4c7d-9825-c823f35a2825', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5562a9b9-ebc6-46cd-90c9-8de60b163cd0', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5586d047-22d7-46fa-bcc2-b2b4b9e4893b', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '559c6012-eec1-4833-b058-684ad400d52b', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5608c526-20aa-4ea7-b71e-4b7831c36982', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '566c3c26-186f-47b3-a22b-c763b54febe8', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '573e528a-a9ea-4821-a5d7-42f92212135f', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5752308b-e6ff-48e1-9960-53eac68111e7', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '57616221-6ae5-48de-b4a8-52886553ac8f', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '576ec827-1ca5-430a-ae65-f2f1a07f62e9', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '577e04f0-22da-4d96-b4e9-f08296e9be11', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '57c25d46-7a2b-488d-921c-6ea73c70626c', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '57d7f59f-1c4a-47b8-a1fb-a90033c26d48', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '58036de1-7923-4488-9819-cedb636ef9c6', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '581e1a3a-bec6-4ba3-b0c3-d85c26c95d14', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '581e655c-9ea8-45ac-8ff5-8ebe9262af58', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '58299598-b27c-4759-963a-b2f01113c758', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '58326902-8dfa-4dbe-876a-ac8e74db3601', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '58402313-5711-4d08-bdce-3cbff6540a0e', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5909c55b-6a44-4118-94e9-544219aa7d9c', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5916e803-107c-42c1-ae0e-260ff15394be', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '591b3f81-2a4a-4e0c-bf58-a35fe56e4dc1', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '593496a4-7f69-4004-9eb9-33ac428a23a9', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '598876da-44e5-4f56-b2d6-2889fbdef674', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '59b00391-11b0-4d9c-93cf-218488e9319a', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '59d9ae62-7fbd-41f5-be4d-37627dcb99e7', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '59df47e4-11c0-4784-8c56-fe8890e7aff9', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '59f9f9d9-317c-48db-bf04-c5186f4a5cf8', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5a1b36db-e0fd-464c-940b-4bb48a2113b5', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5a3cdac1-94fa-4723-aa94-6c07bcedce63', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5a4c3b91-2441-43e1-a3f9-a3e2f72626e3', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5a4c6269-c9a3-47bd-950b-b42115e05c91', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5a55daed-587f-421d-afb7-63bc4d09abd1', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5a9821f1-610b-42c2-ba59-2585f75b4454', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5ab223d1-8392-4d6f-92dd-e677d669cca3', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5ac2c1a9-1e7c-45fa-9330-6f5ad9e66f75', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5acfac25-cb17-4085-a935-767e6a0bc076', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5aeb05ca-e4e3-4bec-bd66-000c8f258820', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5af05169-e90d-4196-962d-322e295f3290', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5b077ec7-8eed-4e8a-ae7c-c5a49cc3b39b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5b7c3840-7dc7-4fd3-a27c-ec76d9cd2cf3', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5bce6bd5-84fd-4549-a2c9-fd5a0204713a', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5bd0d28e-d60b-47d2-b106-cfda268b688d', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5bd6cbcc-4fe3-478d-868e-9f5573bc05ac', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5c0853cb-a3c7-4860-bb12-371be2133f7b', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5c09c3e7-07d5-47b6-b8d4-d6caac27add2', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5ce134d0-f6a0-4da9-848d-c589de1620fa', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5ce7cfe6-0887-4ad6-85e6-15c82b913868', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5ce975b6-13bb-45d2-8207-73fd522ad795', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5ce9ef79-4b51-49af-b917-4b8bb71dad00', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5cec13f8-9054-4860-a530-330bc2d53c4d', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5cf07892-5cb1-4dc7-97da-3fc4c1b0fbf9', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5d04c25d-a7f5-48ca-84f5-275a5358cdb8', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5d237ae5-a2c2-4a9b-8fc0-301e50dce069', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5d2646b4-3d2f-4cc2-8638-f9260a3b6f86', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5d315ed5-529b-4e79-9e03-9a1cf723bfad', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5d36421a-56d7-4564-a45b-ca6dc965acee', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5db70af6-17d8-4b32-90dd-6817bb3d4f1e', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5dc3fda7-8b15-44b4-9b1b-a0d849fee08d', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5df4056a-0df7-4906-939e-38f5cb4fe159', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5e2f8779-8856-463e-be15-197e3966b9fa', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5f05ffd7-1800-4121-a13d-d3f652aefcd0', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5f2c26b4-a81d-4834-9580-eb49c33d4249', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5f4d3768-d32d-4fc1-acc1-b66825b99cfb', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5f5f47bf-9aac-4c5b-9220-d05f492f764f', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5f63af55-917d-4d03-b1cd-b79bbac870c7', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5f6567c9-f123-4435-ba7a-87bb60b7b9ef', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5f868a8d-cc1a-4432-afd7-35cb64d38872', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5fa10e93-ddb0-4f7d-8138-d64c3c806b7a', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5fa8dec5-f1f4-46a9-a663-04765316fb4b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '5fbe222f-b7e7-4690-b35e-298ae9006bab', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6028c802-bc22-41bc-bb0b-27cbb6d17421', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '60653eea-3515-4fb1-9de2-b2e708c9ac85', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '60682441-05ee-41ae-8476-b5a38a9c1ec8', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6068e881-5fd0-4b10-b360-14c58bb09321', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '60dbbf27-8569-4a91-bb2e-05c5764aff34', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '60f4ef3d-a95c-41c0-a65a-f9dc413b6d28', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '60fbb1e1-c62c-47ac-8584-1c56c3974ea4', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '613b39cc-4dc5-4f3c-beeb-5a6c32f20000', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '61826bad-f0c7-4089-b03c-240889480cf9', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '618cdbdf-41a7-4dee-915f-0cfacd92d67e', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6193714f-37c6-44be-a1f2-5f64536d6a97', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '61c30f40-fd34-45df-adc5-3eddd8034c3a', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6208ae37-3f6a-4dd9-bb6c-9f7f59afb31e', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '621acc10-615d-4f7a-88e1-2aece41adce9', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '621ae171-08e9-4f80-ba9a-369035990e22', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '629fcc8f-bead-4f33-94d9-b8fb9cbd64d1', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '62b9f6fc-b11b-4139-9dc7-bcb42ee4b862', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '62fa8c26-3969-4e30-9309-465e5ccd1715', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6378e419-ec8d-42b0-981a-70e8372daa30', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '63b139e4-287e-4d9a-b002-e0acf01b0c39', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '63de79ae-0485-4d59-85b2-ec5c5d2a1d6f', false, NULL, NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '63ede61b-9aed-4448-b7d8-12342b7e65f0', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '63f29e5b-0446-447a-b77a-8d139c9c26eb', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '640e28f5-8c4f-4b9f-861e-b3c67fc1f893', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '64544ea9-e483-4273-ba73-6313dfdfa138', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '648fbe4d-2e56-4262-8a19-fa6e7fc3443b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '649b43b7-4e00-4e83-9bb7-444f8cd0a397', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '64bd6ef5-e516-4558-8273-d7949daeccac', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '64f0849c-b117-460d-a3c5-d485e1a1d414', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '65011b80-2853-4e12-aae9-b41f00758ac9', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '650b40de-4e0b-4666-8ac5-e8c793b73785', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '65191765-0a1a-46a6-9283-9eb0a69ef391', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6534f201-cedd-4972-8e0d-e16de1cf2deb', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '653f2aa6-2e5a-4864-ba25-f368c42c43fa', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '65da9102-b166-4488-b33e-150bd160a99b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '65f1af77-838a-4dc5-a221-e2c52a09bac1', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '66751473-dc89-442b-8b53-6153cb1e9546', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '66a53c49-5896-4c58-ab5b-118de7df4fa3', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '66c868ef-d46b-4097-9942-701977300f36', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '66d6d522-73bb-4cbb-96ab-1e6544e575c7', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '66d9a82d-d772-48b7-ba09-3f6d665d4d24', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '670d1d4c-4682-4c35-8ae3-712647880d92', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '671298ac-13b8-4091-91ed-5756ed243974', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '67267ba7-1bd3-4df4-a427-f1f33909c867', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '67280ccf-e0a7-47e9-85fd-b82bebc4a3c3', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '67398b16-e484-438f-86b7-350f669762f5', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6775b42e-edcf-4dd4-9f17-4b43f0659bbb', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '679dfc37-229c-4c2b-84de-f093298401b3', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '67dbce55-7906-4d8e-9df5-60583084a061', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '67e4213e-bae9-41be-88f3-d9d316b4453e', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '67e451df-201c-495d-bbc6-c74f11e03092', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '67f1e845-1d14-4545-a6a9-7cefbb535663', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '67fbbaa4-1ad6-40b7-96cc-99e52d45d81b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '686a0ecd-f50e-420d-b31a-043a3e16c2a3', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '686a2fa1-7ecc-4650-a734-adb4d7070b30', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '68f24d9f-fd0f-4e42-8f7b-88072f590cc0', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6904c930-daaa-43fa-a80f-2c4ddb04f662', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6940b5e2-febe-46f0-a0ab-0f2cb0485e15', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '697a2904-bdd7-4113-9281-7ff41c17887c', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '697aa674-26b6-4cb8-92f7-0c946c05ae4d', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '69df633f-bed2-4128-9369-ba796cd91185', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '69fb8136-7234-4e7b-a2ad-76d975985baa', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '69fddae0-da63-435e-99ab-fcd000b549a3', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6a1eefb4-ae81-47b4-b486-b961de6b0acb', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6a4c6403-65cc-4549-8e67-d22f26b48c60', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6a5a46e0-a133-4eb2-b586-4a7ea7728175', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6a5b576a-f266-4409-8d0c-513f3495e48f', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6b2e2b6a-f6fa-473c-b8bc-a99bd323e1b5', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6b392102-b466-485f-a9ef-f0eb425e06bf', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6b3d903e-3a22-4cc7-9ae9-8dcfc80813ad', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6b4840dd-2a46-4330-bf0a-dede4f994d38', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6b4f0b5c-83fd-40e9-91df-9452a905d569', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6b61767e-744c-4916-9243-986c5331da35', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6b645ccf-97bc-4c3f-b93e-b39e0e10b8f3', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6b9be66a-116d-4554-8542-ac20ff97cf17', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6ba21447-5d17-40c3-9484-62ac6cb77c3c', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6bcbfa3b-15e6-43c3-b55f-4cb23a860b93', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6bceddda-085b-4b73-af68-ed8178f40349', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6c59cb9c-2362-43e7-977d-ea22fbdb2be9', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6c6bc313-ff3e-4d52-b730-4e1c713768c6', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6c8e1cf0-c5b3-4b29-a125-9c67748d4d58', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6ca4a3af-6fa6-46b6-a2ad-71386f4a5c6b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6cad12c4-c417-4a28-a496-4b378fb7ce3e', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6cb93156-9a14-4532-a69b-b5050bd55eed', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6cbd6977-d06d-401c-9bf5-623a96a65321', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6d4627f1-b127-42c9-94cd-638bf34282da', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6d516ffc-6a66-4d29-8c3d-8fd6247eda70', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6d6a6510-de6b-4b3e-aac6-c907b0e951df', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6d8c453d-0bc4-49e0-9bdd-046f5b432717', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6dad8e34-0a3d-4bd8-b37c-981e2158a0ff', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6db8d21d-9334-4723-a09f-4bfd99296069', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6dbc2399-de1d-4f3d-9b20-3c7cd9beef1d', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6de64d4d-639c-43a7-b22e-2ec886dea42a', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6df6cafb-0f5f-4956-9641-0a2c89fa0737', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6dfcf64c-163e-4e2f-b908-adae0729d976', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6e33a757-add6-4efa-9519-47ac8c4fac88', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6e4fec37-586a-4f42-a9b4-d754eb3f63cb', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6e6a97da-3c40-45f4-8fa9-018945e1b42c', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6e6da2d0-d08a-4270-aa66-c39748b51548', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6e86d8c2-c945-46f2-9c1f-604005a92d6c', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6ed29b22-4cac-4718-a780-0af43076098e', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6f0c4f0c-9264-449b-9ab0-1159a1c806d7', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6f23e190-4fe2-489a-a6cb-7788dc42fde2', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6f594e29-0c43-4db3-b664-11719b87de1b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6f5ad577-7311-4fc5-a052-45b7d5ceef88', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6f7beb87-010f-4b46-a109-bf18df41604d', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '6fa4e85a-dc7f-48ad-b56b-3d055875d840', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '700f1101-337a-4d0f-aecb-02547ce1bfe7', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7027dd8e-c8d3-43eb-b22c-a75b4494510e', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7039b7b2-0253-437b-83f1-64334ecb4b27', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '70692f8c-763e-43c8-a600-898b90c240d5', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '70afdf00-a54e-49b6-a037-43b38b29bc6e', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '71b75992-a334-4eb5-8cef-1e0483373f00', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '71c07659-8a32-49b4-8a0f-d15722484f83', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '71cb61a8-9ceb-4e34-8a81-732e4c98a231', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '71d11a3a-fc0c-4c17-b2a5-94ab59e013b2', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '71e0351c-c9dd-4b0c-9872-629e05d0c849', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '71fa5461-99a2-46a7-9503-a5870de929a6', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '71fabb48-6736-4a17-a8c8-b93f0dfec357', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '720844ca-ce8b-40af-a57b-3b7060a3b6df', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7242dec1-d83f-4d5c-aded-8ccb9c732b3a', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '72845e58-9b79-4c58-b7b8-69841486a18e', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7292ce51-463e-44bc-9056-abcc728fc297', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '729f3544-cd33-4525-8149-9490564e4c33', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '72c88c72-3460-4e83-9921-7d5bbe56626b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '72dfb17d-bd95-4ac2-9f89-4472be66f4f4', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '731e2afb-57f6-4257-9525-9397f5a1b457', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '732cc2fd-0415-406e-8514-4558ef65ed7d', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '732f9565-5e02-404c-8c82-f5cea49ad424', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '73628018-9b3c-41c4-8800-7d9deff7b0e2', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '73d19716-56fe-476c-8dd8-5ea3bfb186ec', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '73e3cda9-d9be-442e-b386-f1071c0e75c6', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '73ee9303-9dfc-4509-9e3e-7d8df1196087', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '746c12c2-582a-49c6-81a1-9d671168c52a', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '74a930b6-a794-4fb3-b788-d88f9b5d1add', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '74ec69b5-ffa6-4917-8483-d3b193f7334e', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '754868e7-1b90-43f8-a83a-2ffa11e7b5ea', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '755abbfb-f9f7-490e-8cf7-a3761b57ce56', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '757439c4-2ae1-4102-bcbe-32b535490b0d', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '75c16c07-ed01-46fc-86b0-7c87c193cf81', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '75cfe27a-f702-4bd6-b83f-c5dea2f20b16', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '760e4c7c-20e8-4994-b376-9b54546bafca', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '762fb8c3-83c0-4b70-85e0-512a14903c25', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7674a55b-8f1e-46a2-94a5-5d358a15d5db', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7689fc10-dcf8-4de2-a4e5-2944a4051d51', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '76c32e6c-e376-4919-a360-43de0f62b4cf', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '76dea80e-a17f-4c7d-99d2-a44b73156f3e', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '76e1eeb5-14eb-4c48-b627-6ac3ba6871b5', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '76ea90f3-e4cc-47bd-86a1-ad471f68590b', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '76ead6b3-61ba-4ae2-b8a1-6fbc0c8ca156', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '76ff463d-9a49-4c1a-81ac-5bb217700ad8', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '770ab96e-fa29-4a7f-8dfb-0e5baedfb52a', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '77423b53-15bd-4f16-9d1f-38f2945d6887', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7742d8b8-dfb2-42cb-ab9a-5ced402585f7', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '774687a6-9d95-4293-a3bb-ca34658268bc', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '77611417-19c4-4517-9f4a-6b00042cdeff', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '77a2aa19-d5f4-4254-a9d3-6960a3230338', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '77d60acc-6edd-4de9-acef-a1d56416151d', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '782eec8a-1315-4e01-a3fd-e64974543b14', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '783e2b64-e766-4e24-9fba-c9ff70810b91', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '787642f2-5b6d-47d3-934a-34def60d4690', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '787a2f9c-f16e-41f9-8176-f399d358ab1e', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '78ff2739-12b2-4703-a6f9-7d99acd89a82', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '79177a61-f261-4480-aa6e-f1b92248182b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7926e3a1-93ba-475e-8860-af77910a7c40', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '793e9bc3-4cbf-4e4c-b166-40a1de5a8954', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '794d6ad7-ec32-4b2c-9a30-1577786b723c', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '79541bc4-34ab-4ad5-bd8c-35ab837de695', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7957e183-d861-4010-a5f9-bc8004244cc7', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '795ff54e-fad9-4cc0-b565-e63310c8028c', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '798befaf-0ac9-48f4-b74a-854e8fbc8271', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '79941529-ef37-498e-9833-cea7ebfcf197', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '799e5b80-8f2d-4bcb-a290-c1aa8da7058c', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '79ebc7c4-5c74-42c2-bb5a-d1b2b50e4741', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7a3a411a-f705-4503-aea7-d74ef14fc3c1', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7a816465-11d5-4ee9-a8dc-3be03b7bfd97', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7a8955fd-8f28-4c7d-9ed4-41548f1cadf4', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7a8ff2cf-deef-4f0a-aacf-9ac862094368', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7ad42f6b-0869-4fe2-b812-dcb33c3f570f', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7add2ab5-9460-4978-b223-944c9261529a', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7aea7c19-f50e-4173-86e2-e998a4556064', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7b050f6d-73fe-411d-b901-d9880095f0c5', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7b27c13c-acc2-4c88-ae83-7389c710e17d', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7b6f907a-a93a-46d1-b585-e522e4eea6c9', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7b81c622-2835-4185-a2be-41fba78b1f26', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7b9737a2-560e-4b61-9ca8-96626eeddbf9', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7bada27e-6271-4a4b-95b8-42d8191facb6', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7baf3224-10d1-4d8e-b0aa-a9a4382fd2c5', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7bc92fd7-2c59-41a7-9a35-25aceda80321', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7bcc126f-652f-493e-86a3-5fe89aa3f713', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7c0973ec-faf1-4b23-acbd-586d59a0b9d5', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7c82642c-ee30-4dd3-97db-7b626431a3c8', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7ca0a1ae-23d0-4bd5-8b28-b1f149d7d87a', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7ca2f9e0-f162-4f78-8ab9-57fd188e2c5d', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7cc3cbb6-3bf2-4af2-a843-c4bef1ae6732', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7cf9e1b8-1e4b-453e-a645-60f4701ca046', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7d0c975d-bf61-4a25-9d8e-05799eed0a46', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7d84fe96-6468-455e-98a5-02b524199256', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7d9e7027-f494-4669-965b-58bd3db0165a', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7daa0b43-031a-4e0c-b049-f36d483d91ac', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7e17c1ff-e335-45d0-8f1e-966acdc13e6b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7e2465d9-fa00-472b-9dd5-62242ba84a04', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7e95ed1c-2af1-4172-9906-d63010b3bfe0', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7ed21854-7602-4227-9fdb-89ff33d2d62d', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7edf3def-83b2-43e0-b359-cc513e46d5b2', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7f18a262-2db0-48ab-806f-6d2169b82724', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7f1b12f5-3748-4f34-812e-9bc09a886287', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7f377e60-30b5-4a88-9f55-9c99264fb443', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7faec045-4612-4d01-b47c-97f9eb0de4aa', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7fe5a16d-b892-49c1-9d6c-a72fc3fcd439', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7ff205f0-aa3a-41c0-a2bf-082fabd4999d', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '7ff75c0b-b870-467f-824d-95a326931032', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8003c16f-260f-4862-8a4e-6935e0863fe4', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8032d784-7433-45bb-afa7-5a659b581ac5', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8084185e-4b27-498e-8b32-f44a19abf332', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '809bcb67-4801-47e3-ae76-88e65f853fab', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '80af0b31-4d27-4dbc-bb88-6206ee5d0165', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '80c11de9-3e97-41dd-9c97-dd3cde8ddd72', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '80e441c2-ea4d-4500-bd56-028f6621737a', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '80f77c27-be13-4d0f-b53c-89d0ec7792a2', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8104db52-a59c-4960-8e8a-741e65b8a8cd', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '81055b48-b4be-44b9-b864-ea22db4e08e4', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '81186c8b-66b5-42a6-b502-93736d56209a', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '812572ab-9818-47d9-9c06-7431264feeee', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8160b2c2-6a21-4441-ad2c-73a83386af3a', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '817020b5-5756-4dda-8abd-9281c7805a3e', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '81874f4b-2a77-4429-a986-e14a2847750a', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '81f0b675-e7d4-4e76-b8e5-1ab4092828d3', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '822ff136-7eaf-4758-81dd-7d596e9a3c31', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '82335e87-a8ef-4c9e-bcc9-5b354a83765d', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '82adaef3-e357-42d0-94eb-b78bda70fe33', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '82ba9e6b-7515-4a71-b639-f4127f32b96d', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '82dc10a8-08cb-41e9-a038-3c448cae669a', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '82df3476-91f7-4451-b21d-d8b204c93b12', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '82ea60b3-bcab-4806-bd6f-762e79c2802e', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '82eba2d6-4983-4125-990f-05295d1ff58c', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '83158dfb-da0b-4d3c-936f-63d998dbd581', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '834160da-7e90-4944-b5fe-ea0d6f04dd63', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '837671f8-12e3-4c7a-9217-859f74c29235', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '83d0eb82-fe28-4649-a642-83f8313ebbce', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '83e3005c-8fb4-4135-81be-f6ab4caff4ce', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '844925f3-f678-4503-b0cd-d688b69634e3', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '84745040-7291-4314-a633-3fa388f5ba77', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '84d5159b-0124-46b7-94c9-86d23b11143a', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '854c578d-ab89-46e6-bf8e-8efe680fcbcb', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8564a110-595c-4f50-83ab-6c8039e7fc0c', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '85e0c57f-d657-4e83-80f2-b9fed7965ed8', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8604df40-4a8b-4faf-832b-cf93175a79b6', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '860f3291-7f68-4051-94e8-f28dcb6b70ba', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8624c1ea-2054-4ea7-9078-7468b1c026ff', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '863fbc4c-fb92-4ba3-a0c2-fc510a8cd805', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8666f696-1adc-4fa5-b142-3c999ba4171d', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '86a85985-978a-4854-89a9-5e3c72417b7b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '87242b62-021b-4339-9b35-c73557053ba9', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '876d8d66-946b-45a3-99cd-7d3b9163263e', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '87afde61-82b4-4131-acb2-7d3375670d69', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '87b075f3-5f15-48bb-bd63-cfaa2da4adc3', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '87b7c53d-7ee2-4dbe-ae76-94b8f9262648', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '87d06b86-9561-47a1-9874-665daa5e33dd', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '87ea774a-2b53-4868-b4dc-e76bed2c6682', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '87f5f4ed-09cb-4950-8299-9e36364c059d', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '881ec7e0-ff87-4363-8f5a-2d0261332ede', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '882e1adb-e3cf-416e-83d8-04f6a451cb61', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '884aed43-30f4-4b18-b2ec-fadcfcb71d27', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8885352e-3144-4e4f-b5d5-5b59ce03c001', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '88b24390-cf39-4aab-bdff-6f8b74351453', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '88bed807-45dc-4053-8a48-83db11affef0', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '88c668c6-ac10-4f82-acc4-5220fa09b3e4', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '88ca9eb7-23da-4f73-9c9b-4e872f66cf6b', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8905df40-f1c3-41b1-b2dc-7c8fefb591b9', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '890f23e0-ec31-48dd-9f22-cb13adb5e046', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8979d1b5-ab9f-41ee-960b-f88a2b3823bc', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '89aaf478-4023-4b97-aaf1-3071d4853a9c', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '89c0a3d3-39e8-40f8-be13-6095b78de4cf', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '89d85fe0-5703-40ba-9fe0-a258f039edde', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '89e96c4a-16fe-4521-8538-d953279173b9', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8a297c6a-2cc5-4a40-93da-128766687a51', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8aaa3a1a-ee50-434a-89ef-dc307a936bd5', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8ac28de5-b0a2-445e-8d06-7f275f77d0ca', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8ad8da18-2295-423d-ad95-423a4012a2bf', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8b03511d-6632-4d52-be6c-5f8736f1158d', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8b0f1c02-f5e3-4c26-bb77-2a6508db6d8f', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8b1221db-3d35-4237-af31-7f35605d3856', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8b19d863-0378-4cd1-bce2-7245996d8769', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8b1ef465-aa3a-442b-a072-1b4ab184d483', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8b29ee0b-7248-4bcf-bfce-270083330c19', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8b45da9b-ff89-473e-b5f9-6e65ad1dca05', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8bac83ba-674c-4c48-9b30-213d3b52efc1', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8badd946-31a6-4e05-a680-a1e7223a4981', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8bb8b1f4-456f-41b2-ba86-ca72922a9d14', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8c21cb13-1ea3-4e88-8662-462c97b0e593', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8c334136-edac-49f4-afc1-a71d16fdd467', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8c365a70-b26f-421d-9ac8-eac7c550e9a2', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8c50e5b8-6d00-41ea-9745-bf2930f5f53b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8c626a72-449e-4cde-9b88-05feec146288', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8c76210a-2220-47df-aa3b-68e38becd6ea', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8c7c2fc2-8166-45d5-a3b9-0791379853c9', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8c81ed68-b2f0-417c-ade1-b890f376eb4e', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8c9f921d-086e-4bbd-b8b7-261299d0d886', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8ca511b8-4336-4dac-a276-faa982e0a53e', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8cdc7562-b029-4225-9adf-3af84ca9865f', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8cf4c878-b528-488f-97b4-4e9f6920d6c1', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8d239bde-780b-4256-9c56-98a00350d7a1', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8d2ca7c8-92e1-4762-9ae9-34cd555b98c2', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8e0cd864-e479-4fc0-ba24-4349c94f7f42', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8e3e8f78-e90f-4d2d-96b8-0e160878aea1', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8e4d44f9-eba4-4880-b101-bcd9215a0692', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8e7ee0d0-1551-4af8-8886-a96cbdc4eebd', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8e8529ce-710f-4105-a139-a38ce165db02', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8e94c2d1-b618-4885-acdc-947e3f437794', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8ee573f5-c34c-4b7f-bf9e-d070e5cead1e', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8f273238-a2d7-4787-90e5-f821726cfc91', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8f5c4f4e-0c85-49bb-b669-ac554c7413fe', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8f6f8fc8-a9c4-47ab-b6ee-780d61d8a42c', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8f917c95-2049-4bc1-be18-f42cec159643', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8fa42ce7-ba32-4fb3-8da8-1e9ee276b1f1', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8fb5f615-86ff-4109-b74c-3ceb1ce4f60c', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8fbe47b0-7e65-44bb-92c3-2284cca9c700', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8fd2b1c4-ea58-4b46-9978-ca85a8457d0d', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8fd7dc28-0976-4d47-87da-ddf20577ca85', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '8fe50728-4799-4539-8bc7-88bddbf763b6', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '90677dca-70d2-4808-bd27-128428708e3b', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '90b14156-44d2-45a5-8a97-24f0cec7a970', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '90d25b1a-3e81-488a-87e2-b55600054022', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '90f89cb5-c3e3-43cf-95f5-43805c590bdc', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '911f555a-c77c-4096-9881-8a0381fcbf57', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '912282c4-cd90-4a32-bec2-60505406accf', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '912a923d-d815-4f19-bfad-4fc626b955cd', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '913ecc49-fa0c-45bf-bbb1-6bd54b9107ec', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '918a677f-d913-4f0c-9824-3bfef9ce108c', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9192195e-1e36-43ad-98d3-5645d712a0db', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '91d30bb4-948d-412b-877a-fc5b95b6285a', false, NULL, NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '92155190-0133-4152-b95d-874453dfa6a5', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9223db14-69f7-4ded-9fc0-fcad4fa70bd6', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9264259d-0ba3-40f5-af40-79dc2170b3d2', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9273194d-85b5-4b72-91f6-5f4dbf8bdfcb', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9274e68d-b547-4f97-b36f-72b9dc2a96fc', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '928ece67-c6cd-44f3-b841-bfc1c15c447d', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '92dd6cbd-a310-4e54-9ee6-1d81187e57f5', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '930ff49d-dee7-4d50-bcf9-1941d55c9b5b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '931145c1-82e7-4df5-88bb-760b5fff1fa5', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '931ba65e-3299-4928-bfc7-bb80f2559a68', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9332dca9-de2f-4f07-b426-ab23096b0fee', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '936fc244-b5e7-4c54-95b8-cb19626cf204', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '937ecc93-0592-41cc-9aee-c368d35eb729', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '939a8df5-2ec6-43c6-b8f6-0bceccacd841', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '939d0d43-b2c0-40c2-95fa-f5a38dbbbf5c', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '939e891b-f294-431c-818c-ba01cc813250', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '93bcd2ea-2984-4e61-bf1a-5337f150fa08', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '93be7ead-7c7e-4a64-ae91-98f3b8e5024e', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '93f723d0-600f-4b89-b25d-63b8f93200cb', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '93fa563c-52ca-4568-889b-54bb1e65c07a', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '946acd67-09e1-4edc-ab53-ee62e87952ed', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9475fc00-31c2-4ebe-9432-0ac9f87bba52', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '949948c5-201b-4c7f-b6b7-3e30c6bdf3f2', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '94be2f00-32a5-4eac-8acd-6ac99ecf2f53', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '94d53042-c6e6-4ac8-b7f7-01d2e30034c7', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9510589e-87a4-4f47-8b39-e9364fccae00', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '95224b14-1d8c-4e9f-b11a-61363b3de5aa', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '952af693-75cf-49db-89e2-94983186d4f1', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '95377839-59ef-492a-8922-a58b64365234', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '95457614-4c79-4651-a3cf-3e4a6c16ef40', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '95493627-8013-4ef1-b99b-21db7eb1b7bd', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '954ce85c-8d33-4d18-998a-0d9b3c665885', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '955d70d0-1852-4799-9e1b-73e26f7d6962', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '958421db-344a-4788-91b5-f60084be3f05', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9587ce20-0cf0-4322-810f-ce6ea5c71ed2', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '95cc150c-a82e-49c4-b974-3ff9d78b2d26', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '95e76839-edc6-41c6-ae17-f4aeb141736e', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '96098a4c-56a0-41d1-b73c-d4139b97f460', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9628e357-a000-4a1f-b022-5999f4707b27', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '96418770-4c23-4088-a9cf-d6a42c41b52e', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9644f3d5-7e78-418a-8f55-695b26b7a8ea', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '967d1bca-6381-4c78-a916-aa9b644810b6', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '968b2833-c3a8-4ba3-b9d8-44269cf518bc', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '96ae2052-00c2-4876-b2aa-5748a741934b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '96b64525-9033-47fd-a0dc-ee7927ff58b8', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9734fc29-df7c-4b5d-863b-760021cbe1de', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '976146ca-34a6-4c58-9765-952d4971fcf9', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9797aecc-7d26-4a64-a166-1b1807baff47', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '97b3c34a-3c6e-40c9-b75e-3ee07e619683', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '97b91a4d-5a9c-4954-8f13-3b09bcdbdaf2', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '97be4771-8b01-453f-92d1-56c04a4a4456', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '98371127-d113-4b58-bcb9-ce5f0c47eed4', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '986adaeb-72a1-4767-9372-d55f74357b3d', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9884e752-c192-4092-984d-0b1a49d331dc', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '98c92b27-eee2-4c91-ae2d-1cebbfeed997', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '98d9df28-d781-4159-b24c-b93e119c9f03', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '98dd4631-c0be-4a2b-a51c-c1f06f8467e9', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '990c25fe-85f8-4c58-b69d-9aaf68572b5f', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '99512ba9-18a4-496e-9c1d-1390ce7124e0', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '99642a41-c8ee-472f-8ee5-58ded0285ed6', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '99839b4d-15f8-4940-a5e2-4a06a854d7fa', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '99b486a7-c8d7-419d-9c20-79ae911e4eec', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '99c5b52e-a023-4c23-bba7-a37293ea4326', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '99c68ae7-f32f-467e-a3e3-884cd6ce9097', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9a2d13da-6775-413f-b6d5-975315dcc140', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9a4f0cca-6a28-4590-84c5-5d5add72712c', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9ab9e950-c405-499e-b151-da4af2ece806', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9b07042b-9815-4d94-b736-c245966c0b7a', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9b1bbc60-1ece-4f90-96cb-94eaa8430060', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9b23a52b-f878-44c8-904a-2722a7a2c473', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9b2c9608-f2a1-49af-8b12-09e0acbb587e', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9b66242c-41e3-41ef-a3e5-5d539ac36f21', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9b841ee1-f34b-4e25-9489-d79627789dc4', false, NULL, NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9b8c011e-c61f-427f-ad9e-a21d9bf70ede', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9b9682d3-9707-4db6-b617-78664b01753c', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9bd25539-f3d4-4152-8828-bf79fe8bb6b3', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9bd39ba2-e69c-4cc2-9c90-dc275cb75c2d', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9c0a4812-ebef-4dc2-a7b4-c7a2f31e0601', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9c0f37e1-d90a-495c-8fe1-12b4d0c63b31', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9c2a19d6-de8f-4da4-a4e3-a6bc62b1ef37', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9c69bfc1-345b-4bfb-ab2a-9e5fac4ce141', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9cdbb1a3-98f0-4f65-ab8e-d21c91074405', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9ce66799-c6b7-49e4-a6e6-91064d6b12c3', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9d08de52-78e3-4e71-98c6-4e4fb30b0158', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9d5dba0c-a4c0-4867-92d0-ca4353a235e9', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9dc8f627-434c-4b6b-9e05-4e97b0a978af', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9dd88f39-2869-46dc-bfca-07913f331b2d', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9e96e88c-439e-4946-8210-9f5084314b90', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9e9b42f7-70e0-4714-8ac8-8b9815b2d76c', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9ebcdecf-c58e-4f13-a03b-529234c6ca71', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9ec6e796-fb38-4cde-8fed-84d40846c366', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9ed27378-b76b-47fd-ba2a-c558e2b44239', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9ef121e9-5f16-4dda-b53b-b8248edfaff6', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9f06c393-8db9-412a-8a64-4e088cd53f64', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9f105b3e-aac6-4d75-b8e3-6960eb2bb0f6', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9f2e2a13-f505-4cd8-9a50-0b00432727a6', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9f363829-c79a-4bc9-add0-1cd0be0f7dd7', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9f7fb575-2359-4f0a-a61c-56449e9dcea9', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9fa296d0-cf83-48c3-9faa-958327048fc3', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', '9fa48658-ee2a-44cd-afd9-3db79cf90f17', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a00bffc6-c895-4c80-adf4-659418629397', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a00dbb96-bce0-4371-ac26-2b56ad4e33e7', false, NULL, NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a02078f6-0426-4d6f-bd86-39afd1e38648', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a06bfbfb-26f1-4d13-89ac-3d5a035a6e99', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a0870c6a-1615-4001-adc2-adafa670c01e', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a0894146-8754-45d2-8c16-b33268860c45', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a0c0cbc2-0b7e-45cd-814b-0f907ebc6540', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a0c24358-f7c6-457d-97d4-36bca364196b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a0e366c6-809c-4b7a-9fdc-00948bc4c92e', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a13970b5-6911-416f-b3e1-dd4460c4ae91', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a1640c47-c525-4792-a585-96d66422f595', false, NULL, NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a1731508-795b-4512-bfa8-78d8cbebd1bd', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a183fea0-59b2-4a85-b1ed-12d13fb14b65', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a18a718a-f976-413d-8d5c-4d8d11acbafc', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a18b32ff-dc5a-4f68-bc6f-4559f7fcab82', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a1b9d969-42f0-405e-b710-b418ebe06ed8', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a1c87452-6b53-4636-941e-dd2bc13e3de8', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a248f635-e76f-491d-a960-b688c6fbfcee', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a24db64a-7797-4cd4-8ccb-24f775ef139c', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a255c066-8814-41f2-9190-edae0a78fa46', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a2961ac0-ad4e-4810-adec-f22854388047', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a2b483cb-9032-416e-85e2-c32edc59c232', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a31b4484-f7a9-4782-9bee-487d11534159', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a371f7f0-4def-4b4b-afee-9ee8b1a6488e', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a3f3f7bc-5bd5-4427-ba3a-a957d6ca19b0', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a3f86b3f-0fd8-4ab7-aed3-5c125d9c06d1', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a4403510-aa55-44f5-82a5-b18c370e145c', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a44b3ce8-daa5-4af7-85ec-5024bf6f3d5e', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a46af59c-bc2d-4e30-bab6-4e05ee26ee7d', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a46f06d4-3293-45b5-a078-cc1c04511144', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a4d24989-38b2-4224-bac8-341e46ea88a3', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a4e36b13-208a-4878-90e3-4151574dcbf3', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a4f0206e-84e5-417d-95c8-22395b170af8', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a5255d0a-f082-4993-bdcb-7a93e0af7f40', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a561d6bf-5de2-4a17-b025-cd4096d5f563', false, NULL, NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a568bc71-e739-4a72-90d1-69bb6b0b09e3', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a57890a9-3122-497a-9ca7-972ca052b325', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a596039e-41bf-4892-b0b9-81fe08b0cb12', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a5c79b37-bfa1-4c05-9ca7-944a14d9427d', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a5dc5c2f-c209-4d9b-b515-11ddbe762284', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a6e74ac3-c27e-471a-9e59-85279ea860f0', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a702a53b-a9ce-4a80-8633-8f854a2f15b7', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a70b76db-d574-439f-b8e0-61a806fec0d8', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a7617462-9435-4b59-8d09-e0e63388cebf', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a7636ac9-3ab8-4199-828d-60e411e57326', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a783c470-46d4-4666-b406-150ea321ce1f', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a7842718-6848-4ea8-81d4-7a4ccffc2927', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a78fbea4-3aec-4fcd-8d80-1b750c754514', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a7a0fadc-6792-41fd-b403-67865f57bf1c', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a7d097b9-dddf-4181-9693-cd53bf38d835', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a7da202c-13dc-4023-85d6-831a8db6a3e2', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a809ea74-c71e-4631-81b0-be1fa4888b10', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a8158a19-34c7-4a7d-9229-43ad2d69440e', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a82bf61a-9c12-4ad0-95c7-a37292c5e5b1', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a8349edd-523a-4af8-9159-6539d7585cb4', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a8483632-973c-4325-be56-01cf87a4221d', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a84b838c-32a0-4c5c-aa9e-8beb8b3422cf', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a851ec37-8052-4cfd-8536-8ea8aba837e9', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a85e1d18-6286-4cf0-8a7c-721fb70f325b', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a87c5b90-2ef9-4423-9b50-9ee2bf3d5f6a', false, NULL, NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a8a6fa00-4600-4e83-9299-91292622225e', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a93a7936-3d05-4d60-a954-d43d1c758ade', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a93a8827-2d5f-462f-8ec8-c4b4d941418a', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a9768a47-d9ac-46e4-8640-6b5af2295482', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a9b663b2-4f2c-44f3-a13f-b3324a55ded2', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a9bbcd39-36ed-4e31-a8eb-2ef70ba94014', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'a9bcc70d-605c-4781-8a8e-70cf334f0a18', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'aa0bb658-f6c1-4d60-804c-5fbc968c0cfb', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'aa1f26e8-44d9-4527-8091-e5401a7f2b64', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'aa40e57b-a61c-4ac2-a6a6-079b8349b15e', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'aab6a0ae-1c23-4ea4-bc5c-7f88ded00594', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'aae63935-21f2-4a17-a601-798532558644', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'aae68a40-28ba-4a8f-ac77-de558546da3d', false, NULL, NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'aaed3e0b-3d1d-4d89-b782-79bf7095dbc0', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ab3a002d-9728-407f-9cb8-ce5f4f466eba', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ab5942d9-a6a9-4626-a68b-54c769659130', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ab5ec7a8-d3a5-4099-b234-70892ddaef5a', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ab61c640-05ba-41b4-a9ca-e88c0f317fff', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'aba538ba-f169-490d-937f-94bd0a8cb1e7', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'abc77d87-d01a-4962-8379-9d28c86688c6', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'abced2a5-de59-449f-b634-e1225514b7b7', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'abfcf111-9940-4848-90c0-89f56df20c3c', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ac0e3154-fc90-4ead-9c08-6df24ca6fae1', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ac691170-a7b6-4c41-a2b1-4e8d8977bb67', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ad2ea2bc-b790-4eed-867b-837f9df686a3', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ad6c0a2e-3ff6-44b5-9944-9df0e045c7b1', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ad8073e1-dd7b-410f-bd41-dc4873fe2cb6', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ad94514a-eb29-467c-bdae-51b612e7ecd0', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'add49215-fea0-45b6-a491-92d9fb9592ef', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ae02d9c4-979f-48aa-b226-885e48949d81', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ae66b10f-910d-48d1-b361-e046aaa13dfe', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ae6ec9e1-8cf9-49e4-ac97-083940e35d30', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ae7c4c6c-98dd-40c1-8ff6-77e2f268d65a', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'aeb286f9-0f42-4c83-9152-89bf266bcb6d', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'aec7d28a-6ce9-496c-abe2-47405dec8c12', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'af106b86-c5e4-420e-b3bd-3b538875d1cb', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'af12d95a-6129-41d9-a416-accc3fe7afb7', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'af7955b6-c840-4f18-b2e3-93acd2105771', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'af7e16ae-fec0-40ea-924c-4c46892f383d', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'afcd3d68-3b87-413c-8b53-abe943f82f65', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'afef59fc-c55b-4979-968b-ef505b9a53b0', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'affb1b08-828f-4f8a-b03b-f09e22869b0a', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b0031a40-8de4-482e-a41c-9a759b09c6e9', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b00cf5ea-6774-4fb8-9199-b92698ce0cf0', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b0154522-0510-48b5-bbbb-ec78bc6b6efa', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b0506ce0-53f2-48f2-9d43-152fcf7709c7', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b08508bf-b3c4-44a8-a7d0-d08387a6e024', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b0880e67-fdec-4801-bf72-4d63ddfd435d', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b09ab6d0-a5dd-4d0b-a7f8-31a3a62750ad', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b0f945b5-4be8-4371-a23a-b5958c4479bf', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b11976e5-d7e1-4f8c-85ee-9fdbbeb04f24', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b19ae6dc-d03b-4a61-b0a6-8115ead9adac', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b1c437c2-77f3-4650-a85b-8f8598a27540', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b1f30444-8536-48fa-ae98-6593b5af826f', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b219697e-2b5d-451f-8b08-b3cedbead78c', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b25f2659-d5e3-4dba-a945-d4cfc9755f6d', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b2a2274a-01da-45cb-a757-074498d1dba6', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b2a56a29-cdca-4ac4-909d-56080bec35c0', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b2cbeb0f-dceb-458f-8453-4bf1bfb81ea3', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b2d3e273-b737-4bcf-beb3-23d2c3cd8f26', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b2d987dc-5073-4567-aa9a-3f730be0d148', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b3189ac9-bf63-4a8a-bc58-764dc21f7b9e', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b3536acc-ea92-4e8d-be33-f1a712951c0f', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b3592aab-b657-4a25-b8af-8a89c8527bb7', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b3598ade-a959-4181-94e5-016f06b27d39', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b3afa683-9f42-443b-a1e3-fef03f7f09f7', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b3b2e8b3-4ca5-43a5-97fa-4299df40950f', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b3ba28d1-f64e-4308-ba25-ed05965e7156', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b3bf7995-2e10-44f8-a11b-5702648db632', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b3cf536e-179c-4c71-942c-d434ace3bc0e', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b3e11df1-4795-41cf-b193-9976e1aa24c8', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b4118214-afef-42b7-bd13-e0dd65ac6152', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b49ca0b1-3658-4c4e-987a-7476e3e16065', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b4b6075d-429b-4d6c-bce9-7e7a3cfb70aa', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b4bb3ac7-1d3a-4f50-b5f3-ee49ccd07c7a', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b4bdcb43-de05-43cb-884e-a6f168d420e4', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b508bf59-2b4c-4fb1-96af-f59f90c8ba92', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b534857e-c95a-4fb0-9dda-f4421df4721a', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b5515cb6-95ec-4ba1-ab8c-4368cbb9f721', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b583e371-5db9-4f83-b757-24bd115460db', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b5964b27-10d4-40b2-be45-ddae780e4276', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b5a6bc0d-f640-434a-8b86-4363d25fb161', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b5c5d0fb-e5ed-43e9-bf4f-817718edfd87', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b5edf5bc-7d09-4c54-921d-382585db8e02', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b60f39aa-df13-43f5-86d9-174c42733793', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b640f0d7-b6e2-444e-9359-2418e0688f74', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b646d9d9-bcda-47cd-b628-3096a6cb2e1a', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b64d34a2-19dc-49aa-9b50-b610312e6979', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b6513cb9-80d2-4095-9432-2aff040d7276', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b6598f96-051b-45bb-b8dd-aac216ad68f0', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b675fdd9-b8d9-4c18-9efb-34ec8a54f148', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b67e7711-8a21-4cb4-92a5-c3cccd55ad83', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b685c62c-5aec-45ed-bdc7-6f7d67027023', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b6db2060-4f86-4183-be60-4ffc1c9b2197', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b70e91ca-cbbb-4d11-a1d7-c81156627a6b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b71bc094-3b41-4da0-8b04-fc26dd89b8e9', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b7369aa5-2e41-4f48-81fd-074b046d95a4', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b74d44e8-3ff0-400a-83e8-8fa65d55e333', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b78d290a-01fb-485b-ac05-9593d856486f', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b7e9d30d-b942-40ca-aa21-a8d7bb841148', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b85513d6-0a81-4350-bde3-29cf29f3beff', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b85de429-d3a2-4316-bd64-d101250ed39b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b887cad0-0e91-4fa0-9f31-65a0fd6a2255', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b8a9f331-1239-4e2d-8754-0ad8d65a3202', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b8c4a62f-14f3-41fb-b716-19ea5a029719', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b8c604cb-cf58-4e61-808e-4b89e54d95a9', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b8c87d06-2a86-4a44-b96d-9f836fa7cae0', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b906c6fe-ffcd-4411-a164-421bf4665f4b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b9077bf0-a14b-4732-8e6e-72cde735950c', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b9199b72-0515-4161-8366-df5002dec6df', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b94190b8-dadc-4f4d-82a4-b5b38f972c79', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b992f42d-0cd9-48fe-ad09-de8f4e3dbbdf', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b99fc512-9f65-477f-a506-76a68f11a214', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b9caf228-d2c4-4122-9927-d30b0aa23c33', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b9e91bc5-2967-47e3-b6dc-5e79ab58820b', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b9f6c38e-4625-4048-9934-5ff0e5c65e54', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'b9fcd42a-c324-453b-a15a-bab649259793', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ba1c2e50-74c0-42c5-b49d-4e0cb983a027', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ba3a38b0-f4ab-4596-91f1-d51e17924ac8', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ba53f557-59d2-43e0-aa96-6b38c26f2282', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ba785910-1b12-4b13-ae2f-f32598a26a9a', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ba7d39bb-2c97-4ddb-bb25-35f5f7b95a71', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ba97de43-d760-4880-9e45-574665d0c1d3', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'bad0943f-27e5-4006-b44b-36fddba72f88', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'baf3b4b2-2eee-4bb8-8fc0-cda1f4d4bc1a', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'bafd1df1-6bb5-4afe-a1fa-afb3e97dabb3', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'bb217d56-cbba-47c5-b3d4-0124f18d39fa', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'bb562848-e3b6-4263-9e19-ed658254da84', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'bb59f353-d9ac-4326-9394-bbbdf5f36aaa', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'bbb330cb-7028-4fa9-8ab4-9d2ee83f9dd7', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'bc4916d8-3670-412d-93a6-0edd7025141e', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'bc49739e-544f-4005-9bca-13aac6f11679', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'bce89fbd-95dd-45c0-83c2-875e7fafa21b', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'bd16c2c2-e8e0-43c4-bb5b-beb45a752a27', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'bd382e5d-0269-4bbb-a020-3565d586f088', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'bd4a4c75-10cd-4d1f-bdc3-b1e96774c06e', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'bdcc068e-754e-4f43-9720-595c88959d92', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'be02e4ee-a011-4eaa-84b3-7efed8ef589a', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'be204c07-a10c-4281-a79a-781f60835a45', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'bec516c4-0f22-4f7c-aec0-14bac90f62ae', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'bef89230-6aae-447f-9f31-5c9324d4bcf5', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'bf3b0ff5-c5a9-4a15-a5a9-b2a1e86effae', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'bf5ae960-cc2a-442b-aea3-70b613bf5ab7', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'bf947ae2-b72d-42b5-a613-8145b015be8d', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'bf9c8dba-c857-43cf-b9fd-371f6cd37083', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'bfb656bb-2490-4331-b0c7-6a0687dd4cb4', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'bfca615c-1ff4-4dfa-9cad-5b5c10f8a9c0', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'bfd82b72-415e-4292-b29b-879c117ccb08', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c00e06b9-0f39-4516-bf4e-60ac65ef6ac7', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c00e677d-c096-4303-840e-be5d54e37d21', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c014b0d6-983a-4326-b053-a0c82edc1a16', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c0221458-9410-43e7-91dc-8d36d8c7decc', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c041364f-17c1-4cbf-93c8-92d87f7f039b', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c065326a-df0b-4586-8858-28b7693ab91f', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c0aaaad9-4f7a-47e4-9771-0e4e7f9fb412', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c0fda95e-4584-4b23-9726-1a596aa2aff4', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c173d7cb-1d13-4d6c-9f90-3aad3bd23122', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c19cbcff-4b3a-49de-b8f8-c7b936efc4cf', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c1b7e19c-8ba0-4bcc-8ae4-572e8292a906', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c1bff7dd-a571-4576-be37-89a898d67db1', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c1dbc773-60c7-45ce-b48b-e70bfc41a6f2', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c20036ea-f859-4b50-9797-ff56b9ed3368', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c2031752-0a23-4584-8a30-e0f21a7cf142', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c242a319-12b7-4076-b1c2-d87a48d538af', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c27739db-5156-44a0-9791-13b7f48fb87a', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c2bcdf64-94f5-4a06-a597-f183ec205d48', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c2ccdfe6-82ea-4a3e-b4c7-f1c7a23d0ff6', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c2fc22c9-1d90-4c66-b49a-5a3b540f5d00', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c3306d01-83ae-4975-a7c5-ad2e6626ab08', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c345190a-9f77-43cd-b917-5bef026b1934', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c3730c7d-73c3-4c6e-835a-d133bf4a6920', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c386b6ce-ae2f-4b15-a142-12e03a6c0ff0', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c38f274a-bac0-44d6-ab4f-3e3b6aa498c6', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c3f7f567-d04d-4035-8696-2e1c4435bfe2', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c4002aed-3869-4cce-9309-e0b4be303ff7', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c42302ba-a0a6-457b-995f-f8aa5fdee982', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c42edc32-01d1-493d-b332-2b15a2fd78cb', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c44d20c9-cabe-4142-bd0d-1b8e49ad584d', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c45af2df-ee83-459a-915e-b0852e3980d7', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c49a6beb-710b-402c-b9cc-eaa73a2413dc', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c5241b55-9b50-4e7f-981a-07aa4d4de468', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c55eef10-9422-42fb-9fde-50121fd869c8', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c57c8097-1864-4e2d-ac23-6231874609d2', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c5f4d5d6-1441-4c9d-bde9-5344202bb7a3', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c65cbb53-3799-45d4-8761-2a06c875ed8b', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c68c3e0b-9f4f-4bd9-baec-166f1d46a3b3', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c698a7ee-39d7-4ee1-bacf-ea37f8bb09b0', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c6ab6763-bd2e-47c3-8cec-d03db9b557b4', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c6b94169-1885-463e-9068-c9392f05a423', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c6c065f6-6a1c-4110-90e4-c9898c2343a2', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c6e73c7d-a099-45b6-b4f5-ba3343d1e9e8', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c6fcf54a-0d98-4c14-8c7c-5d0cd6e8dc17', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c72462e3-4db1-4870-a9c7-8feee3677518', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c729a634-c346-4f48-8781-8c8b203c07e1', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c72ca8fc-3e40-4ec6-b265-1934f77ca224', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c77b9481-6fa6-4038-83db-7514d91bb826', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c7972394-f060-4236-8b8d-5684b1764dfc', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c7c4cecb-e862-4fe3-b4b7-c6590b6d3aa3', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c822ae3a-75e2-4fd0-ae3c-17ac4107b437', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c869a154-826a-45e3-a993-76f26be60b03', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c8783223-6b94-4754-b87e-7537398a6ce9', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c890df94-bbd9-441d-ae0f-480ba7fa1ef6', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c8f03fdd-65b7-4fe6-b3ed-acab86c73993', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c8f5b31d-da18-4f83-a1d9-ea1299e31835', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c8fdb0dd-cd70-4413-b0d4-8dfcd55002ac', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c9209b6e-9601-4bc8-be3c-e20702decc0f', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c97868e4-9835-4275-a0ab-83d301e835bf', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c9a972c6-32db-4a7b-a98e-75856b4510f7', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c9ba1de3-18e7-4275-8c42-d61c73a9656d', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'c9fde72c-962b-471c-9518-1fb18c491c59', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ca0ff331-9e4f-457f-8dc6-ca106b00a3ed', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ca17646f-9982-4966-9d45-13164886a9d1', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ca202509-ee11-4c0f-947b-5f657874a783', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ca59776f-2e8f-46ff-9d01-803aa4e0f417', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'cac9ab4e-4207-48f5-bc28-e505360efe10', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'caffc118-640b-4a15-b47c-e3e6e486cd72', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'cb7aff5b-03ed-46f6-aa75-a3ec0009fa70', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'cb8aad00-9abb-48ed-ae5b-b96677cf0775', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'cc104ca2-7a3f-4dd7-a14e-5ec7a0fb0cfe', false, NULL, NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'cc1fc39c-cfe6-467d-bebf-f0a6aebc94d5', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'cc82e544-016b-42f0-91f2-f7a1884bc586', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ccac453b-d471-4158-8a50-1ec24e1a8562', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'cdadde25-0b24-4bd5-ae2d-85ce2af86a80', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'cdee2849-380c-4fd0-9fc9-c85f919c78a2', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ce23cb24-42b0-41cd-b4a3-e524284dff9e', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ce4b2d6e-d822-4137-9ec9-094e405b220f', false, NULL, NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ce8f7a0f-01ba-4def-aeeb-f9356ce9d493', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ceabae40-1436-4e1b-8667-0ad75cf0659e', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ced8866d-1ce8-4fc8-8ddb-e177d4ef166c', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'cefddbb1-d95f-45ba-b883-3d13b025111e', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'cf330977-8bd6-48d2-9769-8e8a07794673', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'cf731919-234b-47d7-8bb8-d1bb721969b5', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'cf932019-528c-4e3b-9de1-05f8df31ec14', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'cfaa002c-ee32-4cae-a5e6-7613deb39560', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'cfb4f542-ad4c-48be-b63e-14d28313c861', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd01f0f7b-6548-4cee-9973-a3d2aff349bc', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd07dcf4f-3003-487e-bc32-3f4f995895cf', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd0a762e2-f059-42fa-9dcc-30878c788c25', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd0d42bb3-25fb-4d10-8fe4-9540ee44e7b3', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd0f11219-c7d6-4101-8b01-34ed497ad894', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd1193b2a-fd3f-4996-a9b4-a89bc64e2f32', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd175c6e1-fd15-4dcb-a005-bbc52132d736', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd17f4488-d375-4efd-8e16-23d8c48c70b8', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd1a77d90-9718-44eb-85ee-6f4ed0af8e53', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd1d7b4d9-71e2-4507-a901-e90c83b2ef8e', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd208ca61-f5c1-4220-aab7-519b82001b38', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd2403ac2-200a-4316-92ad-b8301d257a02', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd25e8bb4-c577-4d0c-96fb-aa214588f7fa', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd2720fd2-2709-4fca-9ea7-eb083e820f34', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd29cb813-ad18-47fd-8079-0390ef815fa4', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd2fe64fa-f2f0-44d3-a252-6d57a5ebff17', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd303d558-bb04-4285-9f59-c0e66df08874', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd329a519-1e99-4462-8ba6-d9982c9e47d8', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd33ab408-f169-4b6a-9861-a943d5a35fb4', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd33b6950-3656-4c96-90b9-a3b86b2cdf8d', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd355409a-e0b9-4bf7-bed4-f042f312c082', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd3b8ed97-9d43-4b5d-9064-caad0577ca9e', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd3c389ea-d028-413b-91dd-364de8852d3c', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd3f0124d-767b-42da-9e67-de7846446d22', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd414df31-4bc1-40ea-adf3-21725a55174a', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd435e84a-0c5c-4a3d-997c-2d9a235b6d7e', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd43e6942-775d-425d-bf65-a64213c50d7f', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd447c912-5aff-4eab-a1bc-e5c57b85c881', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd45e921c-1431-4ef0-9b08-48090a8ca3e5', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd466b2b5-4a24-4981-9acf-cd0eba8565c8', false, NULL, NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd4717df3-3bdd-41b2-817c-f44158a55574', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd47487be-693a-497a-9b2c-6f995fd13b5c', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd495f198-a94a-421b-88e3-037268dcecd4', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd4c7f286-a34e-4a57-abd4-27ab73603150', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd4e2b29b-95bb-469d-9449-e634b258aa45', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd506618f-7328-4edc-ba03-1611e9111e91', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd53ef3c3-33e6-4cfe-afc8-30f3ea935e77', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd548e162-376a-46b3-8227-eaa12f3353a5', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd57e2371-befe-42c1-b62a-465fbcd28ade', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd5a28711-fa17-44c5-93d6-a81495511a95', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd5ed77b5-c34a-4f49-a085-8da682aa3b3a', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd63487bb-e595-4b82-9393-80aa25c7ad07', false, NULL, NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd63feab4-38f2-434f-beac-0492ed59dcdf', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd688b614-f1c1-448d-a428-6b954749fa26', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd68e6dc7-82d1-412b-aaa3-d13a0ccddacc', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd6de091a-467e-4249-ad3e-ff3d17cb119c', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd70b37f6-0edc-4a6e-b7e1-029c7c731f82', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd710f445-7a97-43c9-b4e0-27e6a0c667b9', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd7197cad-c70b-40fb-8394-e38e1ccd1791', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd7400535-2c6b-4d80-a472-112715bb9550', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd796084f-53d2-4981-9662-1c61f2d18a59', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd7a50c0c-ec74-412c-bcee-3327b325de6b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd7aae6d0-1dad-4784-8e30-0b5476a37338', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd7d239d6-ea24-4e49-90a7-e2415bf12b82', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd80c2487-ed59-4f66-b953-7af008025ff6', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd82c1d31-9124-448a-b1ea-2f215aecf982', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd83c84b3-2578-4cfa-a8b7-70f29eb57f3d', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd8404c4a-fbdf-48a6-8c2a-0fae89bef58a', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd847e442-adf4-4885-a0c1-406757e718c5', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd86a3fe4-987d-4def-aeaa-303203641a46', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd87f6ac0-030b-4c00-8911-56605236a4b5', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd8be0d15-05fc-411c-9e50-bbc9e07d22d1', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd8c750a6-a7d2-4be5-947b-f0c81fb18d97', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd8fdff35-fc8b-4728-aa91-838f7d408fd5', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd9400372-97d0-46f4-9cb2-7ef75f21a14a', false, NULL, NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd9464abc-4a87-4c7a-a01d-549af79e6a02', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd959c371-fc5b-477b-97c5-4df907f08df0', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd9aca334-8aef-468a-bb50-fc50b47bbc3b', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'd9b8407f-d4c2-4aea-9f84-355d7ad59485', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'da4fa5b3-3e1c-4bd7-a486-52ea6c1d6d88', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'da5ad225-2669-4091-9f04-e4f5776ee622', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'da871054-e41a-4a2f-ba3c-13b4cc609b58', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'da8866cd-52ac-42c1-abe8-14f500055a01', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'dab7ee4b-3cc3-4d48-b53f-59a21339ee2e', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'dac5253f-a26c-46a2-b72d-1db8ec5e3380', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'dae8019e-48b6-48d8-ac9f-efcdee51518b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'db00639a-4930-4f96-99b7-35e7e6d736e1', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'db3374c4-2bfb-423d-bc5c-82a931d402b0', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'db355915-0780-45a5-997a-ca1cf66e7722', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'db3bd481-41d2-4227-97fb-50677e431e87', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'db44d3e7-b16e-4cf3-a5ae-524af9b30230', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'dbe06c87-9126-4a60-8151-43b71a913b57', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'dbfb36a1-36b2-4438-a1ca-267cdeac0fe5', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'dbfd8b81-3d4a-4847-be1a-fead2716f395', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'dc308ef2-8c67-4903-b73d-b6e5f8260f48', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'dc3ecd29-8f5a-4854-b9c9-7ec851a68e61', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'dc616b8d-4a5c-420f-99f5-3a91bb2cbe11', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'dc90133e-4dc3-41ae-a0af-a30a784a4f53', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'dcd89574-272c-4596-a531-b4bcf4fbb4e6', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'dce742e7-5b9d-41e2-ac86-8f7488007467', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'dd0d22dd-8972-493b-b4f6-958297a15289', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'dd0fe497-1ab5-47d1-823e-ec58864698cf', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'dd1bb09c-df02-445c-8786-0e6801ddff00', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'dd285557-3cd5-4866-81dd-20819ead1593', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'dd76056c-8dd8-4f8d-9a64-0d66873fe861', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ddbeab8d-20d2-4a37-89d9-528647c23e49', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ddc74caa-5a1f-4cdc-a33d-c8812a4a3bd2', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'de08af88-76e0-423f-ae41-e63ed569eeb7', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'de133e26-cda7-4709-83ea-a03887336135', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'de142eb3-ed9b-4a96-8c0b-7424af6d6479', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'de334e53-e427-47b3-928b-4914c7ad7c74', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'de3aa7b1-15ea-48a8-84e4-fb1aa32fa47d', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'de48e7d8-129c-4274-a671-9927506735e5', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'de77e1b9-c18f-45a9-beb8-a32ff72bce48', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'de7bc480-f462-432e-8c15-554df705f263', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'de92fa2a-b41f-484d-95ad-b5e8b6102235', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'dea12f7b-45ed-459e-8943-9a8fb1f46323', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ded19e5c-0ae4-46c6-85ce-4da01aea3de2', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'dedcd435-814c-4bd8-9d77-4800efe714fb', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'def1c41a-03a3-494a-ab3b-92ad1a6fde1d', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'df8fe8cc-94ec-4b51-ba2a-1e8a267c7816', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'df903de9-244a-4972-a1c3-05367cf9ec69', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'dfd2b605-4d6e-48eb-89f8-2bb7f3d4ba43', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'dff896d4-3e05-4057-b2a4-e81004ff6aed', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e01b7a41-1bf8-4814-b20e-c4743454a640', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e04b9b40-8b30-4779-a8b2-c5eff22f0335', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e0a5e42f-d796-4863-b3d6-6e26b8290975', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e0b4f2be-9cf1-4b47-ae41-7b71287fd40c', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e10d202d-3d56-42db-a5b7-873d5c74ee25', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e122f201-9c6b-4e97-9c73-f82371851916', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e13c9259-5246-4c84-bb41-73a33f1348f8', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e1481345-df10-4712-aa86-352be0fc2966', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e1569450-cf3b-4ea0-b03f-6a4bcddd4232', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e18a4875-6ca7-461b-8600-2ec53343e104', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e1dc760f-ebad-4c84-9fa6-fe64cab7962e', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e1fb03d5-cce9-4866-826a-90ac5bac610d', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e218b235-3ee7-41ec-b801-54d39784af55', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e23d370f-c4b5-4625-95f4-dc48a663be43', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e249aa26-aa05-4437-a680-d3c2cf29ffed', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e268e787-7cd1-4b59-929c-dd3b7ab608b7', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e2694da8-8bb6-4fc4-847e-9342b604acfb', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e273fb99-f9f7-42f3-95e9-1b71d6d662b0', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e2936b4c-6e85-4165-b22e-08f53b918422', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e2b240fd-a9f3-49a5-82f6-34a7edb398c3', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e2d14620-7653-4051-af8a-9781603e08bc', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e2d3eda9-ddaa-40be-a16d-6379de2ce4e3', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e2ead620-6ce3-4714-83e3-e12a5b489a9c', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e2f9f7a2-4f15-450e-9590-214558510376', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e32a9be1-2c58-4c50-9dd1-b828d962858d', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e3679301-0e4b-49b6-a31a-a4203f80f062', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e3a1a7ae-db27-40ba-9098-acb1cda4aa01', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e4049f84-bbd2-4420-bb0f-baf203d4a23c', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e40e111e-2adc-4372-ae7b-94260c301605', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e4339ce2-18e6-4810-b6f6-63ba5c3acac6', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e440a17a-e7ee-446f-a07a-16fcd8677eb4', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e47c2408-88ed-4c5f-be74-8c32a0592203', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e49f9ba5-f7e0-4c9d-b1e4-8fdddb2166af', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e4cc0a5d-87e0-4398-b69f-f6325a8583f9', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e4e5daff-1b9f-484b-9eec-eec45cc56301', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e525f8e1-0f87-46a5-9723-b3bb21678758', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e541b43d-4671-41d4-933d-2f4c1dad25ff', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e542fc40-d154-4f4e-877e-5356e0dcdfba', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e5817b19-6ad2-4d4b-803e-8034ff82fe0b', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e596860f-538b-4c60-8001-4a577cc708a1', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e5969264-7c39-47c0-b686-ff93a4fd4e7c', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e5ad49c3-b144-448e-b0c8-571dcf7ea96e', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e5e15f05-c62f-4699-83bc-cb1a8f670a50', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e5fcbb1d-5e46-4c78-b9a3-e7453eb649be', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e60275bd-a7b8-4e52-83ac-bd3068a0b5d9', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e6069926-678e-42e0-917d-a0458a34eca4', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e6349b55-7ebb-4d47-becd-4e036a7fa3ee', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e6543e4f-e5b0-47e6-8689-216086c56721', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e67654cd-934c-438b-ad8d-1aac5aaecf9e', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e6802eeb-d012-4a0b-a0c7-a243aded3a86', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e6d081ef-e1f9-4588-9506-f04590eb4c7a', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e72edd12-7ead-40ee-908b-074f7032b459', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e7a46c8f-fceb-4781-8a8d-0ea34e2a8ba1', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e7bbb862-1fd0-4069-a57e-be7d079793af', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e7d2bf74-cd34-47f8-b216-1295fec6a36b', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e839c036-d514-4a4f-8697-89631cadf568', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e83aaa7a-dfcf-455f-9d43-3bc53a4847d4', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e857fc80-a931-4f52-9ee4-931308b159e1', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e87e8807-b385-420f-8225-7f3cfacd4047', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e88b967c-7389-4741-86d0-df6363436f2a', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e88d523f-63bd-4e7e-860e-9b68a6ca5ca5', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e8bc5156-797a-489b-8700-a36eba271cb4', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e949137b-5186-4483-83cc-7172f9a6d0db', false, NULL, NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e9527d8b-5b80-434e-81ea-8ca4b2816b8e', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e9567ef0-dd78-4f4a-bb9f-404968ab2721', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e974b4b4-78b6-44fe-a6fb-babe986d23d6', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e9c43dbd-d5ee-43df-a141-f04406a8df37', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e9c5ca01-12f7-4ded-be82-faf59d9ed48c', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e9ec2a23-03a0-4125-b12f-95cffa41e2b7', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'e9f23dc8-f371-422a-9bcb-501118eae557', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ea179ec2-898d-4654-8055-c401163772f4', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ea1893c9-b45c-4ec4-b9d3-3734555ecf0b', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'eaa15b2f-af04-4980-a45a-cb437540ae28', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'eab5cd5b-b5da-4e59-bdb6-a9426b78162e', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'eaea3298-dd83-460f-8604-dbb36be2defd', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'eaf1ebd1-93be-4418-9f68-614e3b2d3922', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'eaf4b64f-32dd-4af7-8405-d38b266594bf', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'eb3a47a7-ad49-4e1d-a2e9-611b0f065692', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'eb40f59d-7d00-42df-a549-2202cfb99c28', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'eb6e93bc-e33a-4506-84ba-e0172e288ef3', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ebcc0bc6-5025-41d4-8a01-fc458f391113', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ec10a0ac-4064-4a1c-8736-88eed9e51af1', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ec293091-955c-4f86-81cc-4f4957c0827c', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ec86ab6f-f59c-4dd2-aa3b-2592c68b3fb0', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ecad92b7-3844-47c8-b97e-09b62c8dc14c', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ed49b70d-04e7-49a0-8f0d-683cdc6f5b30', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ed58ca1c-17f6-44c6-aa83-674f4661a276', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ed729e7b-4328-4a0b-bc40-ab43907d6099', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ed792b5b-d4ba-4573-9e47-7f9b2be983a2', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ed98bb6d-9fcd-4af7-b07d-47ee6cb9a7c5', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ed9a9581-45b8-4be2-9741-bfba95f7824f', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ede837e6-92b7-4d25-b55e-74d217b68257', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ee208567-ac34-431f-bf26-03d0b0539157', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ee209373-d381-4d06-923c-4812b665fdb3', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ee297e3d-cf7e-467e-8ddc-31e92bc0f500', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ee936c87-8302-4e85-a542-3f6fa0c1d5d7', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'eea586fb-1d5b-4dbf-a88f-5c24717c15a9', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'eebab72e-a256-42fd-87db-dd14bcb013f4', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'eec990e0-6586-4b4b-a512-978efc94845d', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'eed6b77d-83a0-42d0-8d82-e61bfe00caed', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'eedd6ff0-ef08-48a7-a943-d4232ed06a13', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ef1cdf77-6166-4436-b70d-bed108fe3305', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ef3f3e53-03c0-495e-90c4-5a8ebcdf5e2e', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ef60b23c-e10d-4fd9-98ee-c8816b8b1f80', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ef648bb8-5647-4ebb-ab4d-d3f20d80767b', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ef6c553e-7a84-4785-ba0f-9cf934693bc8', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ef79ffe1-de82-4d49-b302-03c9513ec1e6', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'efb4723d-99b2-4bc6-9b1e-05de05691a4c', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'efede870-71c0-406f-acca-d07e26db8783', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f067df0a-508d-4abb-a0e6-f85c0bfb7650', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f089bf8a-ff53-494a-ade9-d967a8dbc031', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f091b276-a02b-4e53-9025-d7d7bd53c59c', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f09aa1e9-b625-4215-9e98-cfb324a65650', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f18e83d5-c900-4e80-a034-5ffbb7903e43', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f1dba129-7a91-498d-9950-49c88bdf5281', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f1f1e59c-83df-42de-a818-bb2d66254366', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f2532b18-e805-4494-9412-32f1e7ad869f', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f2542acd-468a-4f63-85ac-e7981d0d38d5', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f26a07c0-e3a4-45d2-9096-5bcdcaf458b4', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f2c7aa49-2128-4cb1-98e1-733cde0d5518', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f2e1942d-d64b-4724-b920-a396c547578c', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f2e5ae2c-6a3a-4e04-ab1d-d43479dfa56e', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f2e822ff-f39f-47a3-b0cf-e47e9d7f65a7', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f31b461c-bc12-42af-97a1-eaef447eeabf', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f334e452-8d8b-4b4e-8092-cc8c38cbebab', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f350305d-5273-4321-b5b5-92436cce0c7d', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f3b0ec03-92b0-4b0f-a7b2-393a503cf5c9', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f3c1b2d4-fe6c-4fe0-bda0-32849da6091e', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f3d8d325-a143-4ff4-b69c-251fe190f2ce', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f3ed026d-9029-4037-a2ba-d2df99e2125c', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f43fdf13-1cde-4f8b-963b-575fb4378d1d', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f4557369-ddc5-4a79-82cb-1f845e29b01e', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f464fe94-bf8b-4dec-addb-30473d631659', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f475bb39-753b-4a76-98c1-60eda3c88e43', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f47d2b28-0029-4e7c-94b4-0f6e1c1d8736', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f48e0ba8-b551-4fb8-a6e3-f2db94a76011', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f48eafdc-15f2-476e-aab5-2b8f9e47c450', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f492903e-c446-4d34-bb8f-d5585b95a2f7', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f4938a45-a63e-4c2f-bc21-72ca13aaf7d3', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f521d87f-647e-4954-9496-d963ed7d3ecd', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f52e5e73-d4d8-4608-970a-80ced18b7abd', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f5ae47b3-5f64-4f55-a7bf-6ba8b8d4f716', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f5b7f5e7-df18-4ff1-bdd5-8c3803227c20', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f5f9ac76-85ba-409a-bcee-a4c44bd6d2ae', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f6afa60a-ddf8-4dad-9351-6381f03cd683', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f6b792d0-b558-4d95-bbe4-d49c92f3d6c1', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f6c32302-da9d-4d03-aa70-fa50e44d660c', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f704d299-33ab-4d8e-b2c4-8f7830383621', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f7102693-1118-46af-8b1f-46f0e66e51ad', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f71849bd-a746-466d-bd0d-bec5a3a8ba72', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f74cb069-7ca8-404c-bfdb-ce37f385ea49', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f74f8776-3ab1-4825-9d93-f745f4436cc6', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f751bf3c-2a8e-4cc0-b24a-a6e6377ab4b4', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f762ea29-40a2-41b7-ac33-b42eb013be3f', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f7965b66-edae-454e-90a7-ffce738ef36b', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f79718cf-158a-4c72-af73-bb8aff248467', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f7b4ac90-ee9b-41e3-9243-b48bc5c3651a', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f7fc48a7-81d5-4b71-a7d6-d04b45980133', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f854ac05-c3df-4e17-af9c-0bd58caf9f05', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f8d4906f-6545-4068-966a-ffc16cfbe33a', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f8d73994-b586-4656-927a-fbd18994dfbf', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f8f21305-a403-4897-9d2f-2afc2399dcc0', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f8f8f822-8196-4a89-8df1-d66a69f1513a', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f913c14c-c2aa-410b-bb15-ae6be0eb384c', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f99a2519-70d0-424e-92ca-666af9124a59', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f99d4334-6ea6-404c-8a8a-5207a1a050f0', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f9dab3b1-4747-4f26-b053-5754b6511b2a', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'f9fcd453-9517-4661-bba6-44ead9474d82', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fa65122f-1e67-46b4-93fb-989370e49812', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fa9115f1-3877-467e-a4b1-f923fe14edc3', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fa9467c1-37b3-401f-ab39-a627a619598c', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fac60eb9-03e0-44c9-a92f-52f3d6d56682', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fae00684-8a28-443a-849f-a64246cc8ce3', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fb4554a8-c6dd-47ad-970b-567fa6ff12d4', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fb599f78-b769-4d42-8f0c-0afb5ca2d8e2', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fb7784c7-e40a-43e5-ad5b-dbfc3d64ad92', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fb8c9cbf-7c18-4b0e-81ea-a568d410816d', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fb8efe7d-b184-40cd-b989-a5db3579c3b7', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fb9f4692-dfa5-442e-98e7-6a348bb09c7a', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fbc0ee11-7597-4c3e-b39b-7047c61b2f03', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fbd6b050-4f8d-41dc-9aa7-81facc20aa01', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fbffc17c-f06d-4b90-9ae5-c4072eeb329c', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fcc5ca57-dd89-4711-8524-35eb092bdc16', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fcea7bc7-4e1a-45ea-94ad-8d02e6799d5e', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fd12c60d-4fa8-4f28-aa76-54c2ee1a3c20', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fd20f2e9-b236-4564-8895-5bc9112540ef', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fd60e95b-ae97-47b5-9c96-d407baa405be', true, '2026-04-20 15:36:48.471294', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fd68d4ca-1578-4545-a4a0-1ad78e65cbb0', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fd7d5869-d06c-42ee-a7bd-7aaf0852c4ac', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fdc63878-b703-48dc-b17c-2f2636f40a54', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fde81a2e-f5ec-479e-a66b-f3f1e82a4953', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fe073bb8-df6c-4b2a-802e-51b5528f70d5', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fe1107c5-3147-493b-99d3-0787c6f8bb13', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fe11f8c9-17ef-407d-b677-d6d9682075b1', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fe427a5f-749d-49a8-81fb-c04a1dd61a3b', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fe99bfd0-3e81-4171-afd1-3298db8626f1', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fea607f6-98bb-4de9-be29-c8581e62fca0', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'febf4bfb-c39f-49e8-998d-aba7ecfe36f1', true, '2026-04-20 15:36:48.415614', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fed4dffa-dc31-4bca-b57b-08c9519a71f1', true, '2026-04-20 15:36:48.454075', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'fee6b8f5-a77b-42f1-b87f-a98c0f0f6fab', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
INSERT INTO user_cards (user_id, card_id, is_owned, acquired_at, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001', 'ff722df6-db36-4c4a-85f4-5427b3ff4ee6', true, '2026-04-20 15:36:48.434411', NOW(), NOW())
ON CONFLICT (user_id, card_id) DO NOTHING;
