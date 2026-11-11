# Side Project — Rails Lottery and Rewards Application

A Ruby on Rails web application for client accounts, virtual-coin lottery entries, shop offers, orders, prize winners, shipping addresses, referrals, and an administrator dashboard.

> **Project status:** Development / learning project. This repository is **not production-ready**. In particular, virtual-coin accounting, authorization, payment/order transitions, and prize workflows require thorough testing and review before deployment.

## Contents

1. [Technology stack](#technology-stack)
2. [Prerequisites](#prerequisites)
3. [Download the code](#download-the-code)
4. [Environment and security](#environment-and-security)
5. [Run locally with Docker](#run-locally-with-docker)
6. [Configure local domains](#configure-local-domains)
7. [Create a test account](#create-a-test-account)
8. [Run automated tests](#run-automated-tests)
9. [Manual testing checklist](#manual-testing-checklist)
10. [Common problems and troubleshooting](#common-problems-and-troubleshooting)
11. [Useful commands](#useful-commands)
12. [Project structure](#project-structure)
13. [Contributing and safety notes](#contributing-and-safety-notes)

## Technology stack

| Component | Technology |
| --- | --- |
| Backend | Ruby **3.0.4**, Ruby on Rails **~> 7.0.4** |
| Database | MariaDB **10.5.13** (Rails `mysql2` adapter) |
| Cache / service | Redis |
| Authentication | Devise |
| State transitions | AASM |
| File uploads | CarrierWave |
| Pagination | Kaminari |
| QR codes | RQRCode |
| Frontend | Rails ERB, JavaScript, Bootstrap-based views |
| Local environment | Docker Compose |

These versions reflect the repository's `Gemfile` and `docker-compose.yml`, not necessarily the latest supported releases.

## Prerequisites

For **Windows 10/11**, install:

- [Git for Windows](https://git-scm.com/downloads/win)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (with its WSL 2 backend enabled)
- [Visual Studio Code](https://code.visualstudio.com/) (optional)

Start Docker Desktop and wait until the Docker engine is running. Open **PowerShell** and verify:

```powershell
git --version
docker --version
docker compose version
```

If a command is not recognized, finish installing the corresponding application and reopen PowerShell.

**Linux/macOS:** The same Docker Compose commands generally apply, but installation and hosts-file instructions differ.

## Download the code

To clone the repository:

```powershell
git clone https://github.com/bryn-espiritu/side_project.git
cd side_project
```

To test the fixes proposed in [Pull Request #1](https://github.com/bryn-espiritu/side_project/pull/1):

```powershell
git fetch origin
git switch fix/security-and-lottery-integrity
git pull --ff-only
git branch --show-current
```

The branch command should print `fix/security-and-lottery-integrity`. This branch is separate from `main`.

## Environment and security

### 1. Create a local `.env` file

In the repository root (the directory containing `docker-compose.yml`), create a file named `.env`:

```dotenv
DB_PASSWORD=replace-this-with-a-unique-strong-local-password
```

Docker Compose reads this file when expanding `DB_PASSWORD`. Do not add quotes unless you understand Docker Compose's `.env` syntax.

**Never commit `.env`, credentials, tokens, or real user data.** The `.env` file is ignored by Git in this branch. For additional protection, use a password that you do not reuse anywhere else.

The development and test databases use `DB_PASSWORD` through `config/database.yml`. Production also has its own `APP_DATABASE_PASSWORD` setting; this README does not provide production deployment instructions.

### 2. Previously exposed password

An earlier version of this repository contained a hardcoded database password. If that password was used on any real or publicly accessible database, **rotate it**. Moving a password into an environment variable does not erase it from Git history.

### 3. Docker security caveats

The current `docker-compose.yml` publishes ports **3000**, **1234**, **3306**, and **6379**. It also mounts the host's `~/.ssh` directory read-only into the app container. These are **development-only** settings. Review/remove unnecessary ports and the SSH mount before using the project on an untrusted network. Avoid exposing the database or Redis to the internet.

## Run locally with Docker

All commands in this section are run from the repository root.

### Step 1 — Build the Rails container

```powershell
docker compose build
```

The first build downloads a Ruby base image and installs dependencies, so it may take several minutes.

> **Legacy dependency warning:** The existing Dockerfile uses Ruby 3.0.4 and older Node/Yarn installation commands, including a Python 2.7 package. Some external package repositories or dependencies may no longer be available. A build failure here may require a Dockerfile/dependency upgrade; it does not necessarily indicate a mistake in your commands.

### Step 2 — Start the database and Redis

```powershell
docker compose up -d db redis
docker compose ps
```

Wait for MariaDB to initialize before running database commands. You can inspect startup messages:

```powershell
docker compose logs --tail=80 db
```

### Step 3 — Prepare the Rails database

```powershell
docker compose run --rm app bin/rails db:prepare
```

This creates the development database and loads its schema or applies migrations as needed. It does **not** automatically create sample users or lottery items unless seeds are defined and executed.

If the database reports a connection error, wait a few seconds for MariaDB and retry. Check `docker compose logs db` if it persists.

### Step 4 — Start the Rails server

The current Compose file has **no explicit app server command**. Start Rails in the foreground:

```powershell
docker compose run --rm --service-ports app bin/rails server -b 0.0.0.0 -p 3000
```

Leave this PowerShell window open while testing. The Rails server should listen on port **3000**. Open another PowerShell window for commands that need to run while the server is active.

If Rails reports a stale server PID, stop the server and remove `tmp/pids/server.pid` in the project directory, then restart it.

### Step 5 — Check whether the containers are running

In a second PowerShell window:

```powershell
cd side_project
docker compose ps
```

If you started Rails using `docker compose run --rm`, the one-off app container may have a generated name instead of the regular `app` service name. Use `docker compose run --rm app ...` for additional Rails commands, rather than assuming `docker compose exec app ...` will always work.

## Configure local domains

The Rails routes use host-based constraints: **`client.com`** for the client interface and **`admin.com`** for the admin interface in development. The file `config/domain.yml` specifies these names.

### Windows hosts file

1. Open **Notepad as Administrator**.
2. In Notepad, open `C:\Windows\System32\drivers\etc\hosts`. Choose *All Files* in the file dialog if the hosts file is not shown.
3. Add these two lines at the bottom:

```text
127.0.0.1 client.com
127.0.0.1 admin.com
```

4. Save the file.
5. If the domains still resolve incorrectly, run `ipconfig /flushdns` in PowerShell.

Open the local development URLs:

- **Client:** http://client.com:3000
- **Admin:** http://admin.com:3000

**Important:** These are *local development* addresses, not links to an internet-hosted instance. Do not browse to these domains unless your hosts file maps them to `127.0.0.1`.

If you see a **Blocked host** error, review the Rails development `config.hosts` setting and explicitly allow only the development hostnames you need. Avoid globally disabling host authorization.

### macOS/Linux

Edit `/etc/hosts` with administrator privileges and add the same two lines. Do not modify DNS settings for other machines.

## Create a test account

1. Open http://client.com:3000.
2. Navigate to the registration page.
3. Create a **dummy account**, not an account containing real personal information.
4. Sign in and check the client pages.

### Admin test account

An admin account requires the `admin` role. For **local testing only**, you can promote a dummy account you own after registering it:

```powershell
docker compose run --rm app bin/rails runner "u = User.find_by!(email: 'test-admin@example.test'); u.update!(role: :admin); puts u.role"
```

Replace `test-admin@example.test` with the email of your dummy account. This command does **not** create an account; it updates an existing one. Never use it to promote an untrusted account or on a production database.

The admin authentication flow is different from the client flow and is one of the changes requiring verification. If the admin sign-in fails, capture the Rails error rather than assuming it is working.

## Run automated tests

Run the Rails test suite in an isolated **test environment**:

```powershell
docker compose run --rm -e RAILS_ENV=test app bin/rails db:prepare
docker compose run --rm -e RAILS_ENV=test app bin/rails test
```

The test database is named `side_project_test`, separate from the development database. **Do not point tests at production data.**

**Current limitation:** This repository has limited/no substantive application tests. A successful `bin/rails test` command alone does **not** prove the new fixes are correct. Add controller/request tests, model tests, and concurrency tests for the sensitive workflows before merging.

You can also check whether Rails can load the application and show its routes:

```powershell
docker compose run --rm app bin/rails zeitwerk:check
docker compose run --rm app bin/rails routes
```

## Manual testing checklist

Test with **two separate client accounts** (Client A and Client B), plus a separate admin test account. Do not use real money or real personal data.

| Test | Steps | Expected result |
| --- | --- | --- |
| Client registration | Register and log in as Client A | Client A can access their own pages |
| Admin protection | Visit an admin page while logged out | Login is required |
| Admin role protection | Attempt admin access with a normal client | Access is denied |
| Client addresses | Create an address for Client A; try accessing its edit/update/delete routes as Client B | Client B cannot modify Client A's address |
| Orders | Create orders under both client accounts; view the order list as Client A | Client A sees only their own orders |
| Prize ownership | Attempt to edit/claim/share Client A's winner as Client B | Client B cannot modify it |
| Lottery balance | Give a dummy client test coins, then place valid bets | Each accepted entry deducts the expected amount |
| Insufficient coins | Attempt more entries than the account can afford | Request is rejected without partial deductions |
| Invalid bet quantity | Try 0, negative, nonnumeric, and very large quantities | Invalid quantities are rejected |
| Repeat/double submission | Submit bets rapidly in separate browser tabs | Balance never goes negative; entries and deductions remain consistent |
| Shop modals | Open different offer cards | Each button opens the correct offer modal |
| Carousel | Navigate multiple banners | Only the current banner is active |
| Admin item actions | End an eligible lottery from the admin UI | Action completes or shows a meaningful error, without a missing-template page |

**Coin test data:** If you need to add coins to a dummy local account, use a Rails console or runner **only in your local development database**, and record the before/after balances. Do not modify other users' balances.

**Known areas still requiring review:** Order payment/refund concurrency, winner selection, all state-machine transitions, and the full admin Devise login path have not been comprehensively validated. Treat this pull request as a work in progress.

## Common problems and troubleshooting

### `DB_PASSWORD` is not set

Confirm a file named `.env` exists next to `docker-compose.yml` and contains a `DB_PASSWORD=...` entry. Run:

```powershell
docker compose config
```

**Caution:** `docker compose config` may print resolved secrets. Do not paste its full output into public issues or chats.

### `Access denied for user 'root'`

If MariaDB's persistent data directory (`./tmp/db`) was initialized with an older password, changing `.env` alone will not reset the database's stored credentials. Restore the original local credentials or follow MariaDB's password-reset process. **Do not delete `tmp/db` if it contains data you need.**

### Database connection refused

MariaDB may still be initializing. Check:

```powershell
docker compose ps
docker compose logs --tail=100 db
```

Retry `db:prepare` after the database is ready.

### Port already in use

Check for another process or container using ports `3000`, `3306`, or `6379`. Stop the conflicting service, or adjust the local port mapping and corresponding URL. Do not expose unnecessary service ports publicly.

### Rails won't start / dependency build fails

Capture the last part of the output from:

```powershell
docker compose build --progress=plain
```

The legacy Ruby/Node/Python installation steps may require modernization. Avoid changing multiple dependencies blindly; update and test incrementally.

### `docker compose exec app` says service is not running

The server instructions above use a **one-off** `docker compose run` container. Use `docker compose run --rm app bin/rails ...` for Rails commands, or start a persistent `app` service before using `exec`.

### A page returns 404 or no route matches

Check the hostname: the client and admin routes are constrained by the request host. Verify the Windows hosts file, the URL, and `config/domain.yml`. Inspect routes with:

```powershell
docker compose run --rm app bin/rails routes
```

### `Blocked host`

Rails host authorization may reject `client.com` or `admin.com`. Add these exact development hostnames to the development environment's allowed hosts; do not disable the protection globally.

### See application logs

For a Rails server running in the foreground, read its PowerShell output. For service logs:

```powershell
docker compose logs --tail=100 db
docker compose logs --tail=100 redis
```

Do not share passwords, session cookies, tokens, or personal data in error reports.

## Useful commands

Run from the project root:

| Goal | Command |
| --- | --- |
| Build images | `docker compose build` |
| Start dependencies | `docker compose up -d db redis` |
| Start Rails | `docker compose run --rm --service-ports app bin/rails s -b 0.0.0.0 -p 3000` |
| Prepare development DB | `docker compose run --rm app bin/rails db:prepare` |
| Rails console | `docker compose run --rm app bin/rails console` |
| List routes | `docker compose run --rm app bin/rails routes` |
| Run tests | `docker compose run --rm -e RAILS_ENV=test app bin/rails test` |
| Check running services | `docker compose ps` |
| Stop background services | `docker compose down` |

`docker compose down` stops and removes Compose containers/networks. Avoid destructive volume/data cleanup commands unless you deliberately want to reset local data.

## Project structure

```text
side_project/
├── app/
│   ├── controllers/     # Client, admin, and other HTTP actions
│   ├── models/          # Users, bets, items, orders, winners, etc.
│   └── views/           # ERB templates
├── config/
│   ├── database.yml     # Database settings
│   ├── domain.yml       # Development admin/client hostnames
│   └── routes.rb        # Host-constrained routes
├── db/                  # Schema and migrations
├── docker/
│   └── app/Dockerfile   # Rails image build instructions
├── test/                # Rails test directory, if present
├── docker-compose.yml   # Local services
├── Gemfile              # Ruby dependencies
└── README.md
```

### Application concepts

- **User:** A Devise account with `client` or `admin` role.
- **Item / Bet:** A lottery item and an entry associated with a user and coin amount.
- **Winner:** A prize record with claim/sharing lifecycle transitions.
- **Offer / Order:** Shop offers and orders associated with client accounts.
- **Address:** A client's shipping/contact address.
- **Admin interface:** Management screens, protected by authentication and admin-role checks.

## Contributing and safety notes

1. Create a feature branch rather than committing directly to `main`.
2. Make small changes and document the behavior they affect.
3. Run Rails checks and relevant automated/manual tests.
4. Open a pull request describing the changes, risks, and how they were tested.
5. Review authorization and coin/accounting changes especially carefully before merging.

### Pull request under review

The current security and functionality work is tracked in [Pull Request #1](https://github.com/bryn-espiritu/side_project/pull/1). It is intentionally a **draft** until the application boots, tests run, and sensitive workflows are verified.

### References

- [Ruby on Rails Guides](https://guides.rubyonrails.org/)
- [Docker Compose documentation](https://docs.docker.com/compose/)
- [Devise](https://github.com/heartcombo/devise)
- [AASM](https://github.com/aasm/aasm)

---

This is an educational development project. Do not deploy with sample passwords, publicly exposed database/Redis ports, or unreviewed virtual-currency logic.
