#!/usr/bin/env bash
# Seeds three organizations and one project each, straight into the proof Postgres.
#   orgshared   no private label            -> shared server
#   orgprivate  label "proof" + a route      -> private server
#   orgnoroute  label "proof", NO route      -> must be refused
# The legacy project keys come from the shell environment (K_*).
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"; . "$HERE/env.sh"
sudo docker exec -i proof9253c-pg psql -U prisma -d proof9253 -v ON_ERROR_STOP=1 <<SQL
INSERT INTO "User" (id, name, email, "emailVerified") VALUES ('user_proof9253', 'Proof User', 'proof-user@example.invalid', true) ON CONFLICT DO NOTHING;
INSERT INTO "Organization" (id, name, slug, "privateClickHouseLabel", "privateDataplaneSeenAt") VALUES
  ('orgshared',  'Proof Shared',   'proof-shared',  NULL,    NULL),
  ('orgprivate', 'Proof Private',  'proof-private', 'proof', now()),
  ('orgnoroute', 'Proof No Route', 'proof-noroute', 'proof', now()),
  ('orgbadroute', 'Proof Bad Route', 'proof-badroute', 'badlabel', now()),
  ('orgdown', 'Proof Down Route', 'proof-down', 'downlabel', now()),
  ('orgdash', 'Proof Dash Route', 'proof-dash', 'dashlabel', now()),
  ('orgsys', 'Proof System Route', 'proof-sys', 'syslabel', now()),
  ('orgacme', 'Proof Acme Route', 'proof-acme', 'acmelabel', now())
ON CONFLICT DO NOTHING;
INSERT INTO "OrganizationUser" ("userId", "organizationId", role) SELECT 'user_proof9253', id, 'ADMIN' FROM "Organization" WHERE id IN ('orgshared','orgprivate','orgnoroute','orgbadroute','orgdown','orgdash','orgsys','orgacme') ON CONFLICT DO NOTHING;
INSERT INTO "Team" (id, name, slug, "organizationId") VALUES
  ('teamshared','Shared Team','shared-team','orgshared'),
  ('teamprivate','Private Team','private-team','orgprivate'),
  ('teamnoroute','NoRoute Team','noroute-team','orgnoroute'),
  ('teambad','Bad Team','bad-team','orgbadroute'),
  ('teamdown','Down Team','down-team','orgdown'),
  ('teamdash','Dash Team','dash-team','orgdash'),
  ('teamsys','Sys Team','sys-team','orgsys'),
  ('teamacme','Acme Team','acme-team','orgacme') ON CONFLICT DO NOTHING;
INSERT INTO "TeamUser" ("userId","teamId",role) SELECT 'user_proof9253', id, 'ADMIN' FROM "Team" WHERE id IN ('teamshared','teamprivate','teamnoroute','teambad','teamdown','teamdash','teamsys','teamacme') ON CONFLICT DO NOTHING;
INSERT INTO "Project" (id, name, slug, "apiKey", "teamId", language, framework) VALUES
  ('projshared',  'Shared Project',  'shared-project',  '$K_SHARED',  'teamshared',  'python','other'),
  ('projprivate', 'Private Project', 'private-project', '$K_PRIVATE', 'teamprivate', 'python','other'),
  ('projnoroute', 'NoRoute Project', 'noroute-project', '$K_NOROUTE', 'teamnoroute', 'python','other'),
  ('projbadroute', 'BadRoute Project', 'badroute-project', '$K_BADROUTE', 'teambad', 'python','other'),
  ('projdown', 'Down Project', 'down-project', '$K_DOWN', 'teamdown', 'python','other'),
  ('projdash', 'Dash Project', 'dash-project', '$K_DASH', 'teamdash', 'python','other'),
  ('projsys', 'Sys Project', 'sys-project', '$K_SYS', 'teamsys', 'python','other'),
  ('projacme', 'Acme Project', 'acme-project', '$K_ACME', 'teamacme', 'python','other')
ON CONFLICT DO NOTHING;
SQL
