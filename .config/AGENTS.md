# Parent Config Directory Rules (~/.config/AGENTS.md)

## 1. Dotfiles Repository & Git Invocation

The dotfiles repository is tracked as a bare Git directory at `$HOME/.config/.git` with `$HOME` as the working tree.

Standard `git` commands executed directly inside subdirectories without specifying the Git directory and work tree will fail with work-tree errors. Always use the full dotfiles invocation parameters:

* **Dotfiles Git Command**:
  ```bash
  git --git-dir=$HOME/.config/.git --work-tree=$HOME <command>
  ```
  *(Configured as alias `cfg` in zsh)*

* **Dotfiles Lazygit Command**:
  ```bash
  lazygit --git-dir=$HOME/.config/.git --work-tree=$HOME
  ```
  *(Configured as alias `cflg` in zsh)*

* **Pathspec Resolution & Absolute Paths**:
  When executing dotfiles `git` commands from subdirectories (e.g. `~/.config/nvim`), Git resolves relative pathspecs against the *current working directory* (`$PWD`), not `$HOME`.
  * ❌ **Avoid**: Passing relative paths like `.config/nvim/...` when running from `~/.config/nvim` (causes Git to search for `.config/nvim/.config/nvim/...` and fail with pathspec errors).
  * ✅ **Always use full `$HOME` absolute paths** for file arguments (e.g. `git --git-dir=$HOME/.config/.git --work-tree=$HOME add $HOME/.config/nvim/...`), or run the command with working directory set to `$HOME`.

---

## 2. Git Operation Policies

* **Execute Git Commands Only When Explicitly Requested**:
  * Do **NOT** run proactive `git status`, `git diff`, `git add`, or `git commit` commands during standard code lookups, queries, or edits unless the user explicitly requests Git actions.
* **Post-Change Commit Suggestions**:
  * After completing code changes, simply inform the user that the changes can be committed once they have tested and confirmed that everything is working as intended (e.g., *"Once you test and confirm the changes are working as intended, let me know and we can commit them."*).
  * Do **NOT** run git commands or perform commits until the user gives explicit confirmation and approval.

---

## 3. Git Commit Workflow & Message Guidelines

When the user asks to commit changes, follow these exact steps:

1. **Inspect Staged/Unstaged Changes & Recent History**:
   * Run `git --git-dir=$HOME/.config/.git --work-tree=$HOME status` and `diff` (or `diff --cached`) to analyze exact modifications.
   * Run `git --git-dir=$HOME/.config/.git --work-tree=$HOME log -n 3` to review recent commits and avoid duplicating descriptions of already-committed work.

2. **Message Formatting & Delta Scoping Guidelines**:
   * **Scope Strictly to Current Delta**:
     * Describe ONLY the specific modifications introduced since `HEAD`.
     * Do NOT re-state features, keybindings, or changes that were already committed in preceding steps of the conversation.
   * **Header/Summary**:
     * Keep to 50–72 characters.
     * Follow conventional commit format `<type>(<scope>): <short description>` using lowercase and imperative mood (e.g., `feat(ui): add search bar`, `refactor(zsh): move completion scripts`).
   * **Body/Description**:
     * Separate the header from the body with a blank line.
     * Include a clear explanation of *what* was modified and the rationale/context (*why*) behind the change.
     * Can contain multiple paragraphs if needed.
   * **Example**:
     ```
     refactor(zsh): move completion scripts to custom_completions

     Move _flash_sofle from $ZDOTDIR/functions to $ZDOTDIR/custom_completions and update fpath in ~/.config/zsh/.zshrc.

     This keeps completion definitions separate from general shell functions.
     ```

3. **Executing the Commit**:
   * Stage relevant files using **absolute `$HOME/...` paths**:
     ```bash
     git --git-dir=$HOME/.config/.git --work-tree=$HOME add $HOME/.config/<file1> $HOME/.config/<file2>
     ```
   * Commit with multiple `-m` flags to separate subject line and body paragraphs cleanly:
     ```bash
     git --git-dir=$HOME/.config/.git --work-tree=$HOME commit -m "<Short summary line>" \
                -m "<Detailed body paragraph 1>" \
                -m "<Detailed body paragraph 2>"
     ```

4. **Post-Commit Verification**:
   * Run `git --git-dir=$HOME/.config/.git --work-tree=$HOME log -n 1` to verify the committed message format and output the result to the user.
