use Zef::Commands;

# Content was cut+pasted from bin/zef, leaving bin/zef's contents as just: `use Zef::CLI;`
# This allows the bin/zef original code to be precompiled, halving bare start up time.
# Ideally this all ends up back in bin/zef once/if precompilation of scripts is handled in CURI
package Zef::CLI {
    # TODO: deprecate usage of --depsonly
    @*ARGS = @*ARGS.map: { $_ eq '--depsonly' ?? '--deps-only' !! $_ }

    proto MAIN(|) is export {
        # Supress backtrace
        CATCH { default { try { ::("Rakudo::Internals").?LL-EXCEPTION } ?? .rethrow !! .message.&note; &*EXIT(1) } }
        {*}
    }

#| Download specific distributions
    multi MAIN(
        'fetch',
        Bool :force(:$force-fetch),
        Int  :timeout(:$fetch-timeout),
        :$update,
        *@identities ($, *@)
    ) {
        exit fetch
            |(:$force-fetch   with $force-fetch  ),
            |(:$fetch-timeout with $fetch-timeout),
            |(:$update        with $update       ),
            |@identities
    }

    #| Run tests
    multi MAIN(
        'test',
        Bool :force(:$force-test),
        Int  :timeout(:$test-timeout),
        *@paths ($, *@)
    ) {
        exit test
            |(:$force-test   with $force-test  ),
            |(:$test-timeout with $test-timeout),
            |@paths
    }

    #| Run Build.pm
    multi MAIN(
        'build',
        Bool :force(:$force-build),
        Int  :timeout(:$build-timeout),
        *@paths ($, *@)
    ) {
        exit build
            |(:$force-build   with $force-build  ),
            |(:$build-timeout with $build-timeout),
            |@paths
    }

    #| Install
    multi MAIN(
        'install',
        Bool :$fetch,
        Bool :$build,
        Bool :$test,
        Bool :$depends,
        Bool :$test-depends,
        Bool :$build-depends,
        Bool :$force,
        Bool :$force-resolve,
        Bool :$force-fetch,
        Bool :$force-extract,
        Bool :$force-build,
        Bool :$force-test,
        Bool :$force-install,
        Int  :$timeout,
        Int  :$fetch-timeout,
        Int  :$extract-timeout,
        Int  :$build-timeout,
        Int  :$test-timeout,
        Int  :$install-timeout,
        Bool :$dry,
        Bool :$upgrade,
        Bool :$deps-only,
        Bool :$serial,
        Bool :$contained,
        :$update,
        :$exclude,
        :to(:$install-to),
        *@wants ($, *@)
    ) {
        exit install
            |(:$fetch           with $fetch          ),
            |(:$build           with $build          ),
            |(:$test            with $test           ),
            |(:$depends         with $depends        ),
            |(:$test-depends    with $test-depends   ),
            |(:$build-depends   with $build-depends  ),
            |(:$force           with $force          ),
            |(:$force-resolve   with $force-resolve  ),
            |(:$force-fetch     with $force-fetch    ),
            |(:$force-extract   with $force-extract  ),
            |(:$force-build     with $force-build    ),
            |(:$force-test      with $force-test     ),
            |(:$force-install   with $force-install  ),
            |(:$timeout         with $timeout        ),
            |(:$fetch-timeout   with $fetch-timeout  ),
            |(:$extract-timeout with $extract-timeout),
            |(:$build-timeout   with $build-timeout  ),
            |(:$test-timeout    with $test-timeout   ),
            |(:$install-timeout with $install-timeout),
            |(:$dry             with $dry            ),
            |(:$upgrade         with $upgrade        ),
            |(:$deps-only       with $deps-only      ),
            |(:$serial          with $serial         ),
            |(:$contained       with $contained      ),
            |(:$update          with $update         ),
            |(:$exclude         with $exclude        ),
            |(:$install-to      with $install-to     ),
            |@wants
    }

    #| Uninstall
    multi MAIN(
        'uninstall',
        :from(:$uninstall-from),
        *@identities ($, *@)
    ) {
        exit uninstall
            |(:$uninstall-from with $uninstall-from),
            |@identities
    }

    #| Get a list of possible distribution candidates for the given terms
    multi MAIN('search', Int :$wrap = False, :$update, *@terms ($, *@)) {
        exit search
            |(:$wrap   with $wrap),
            |(:$update with $update),
            |@terms
    }

    #| A list of available modules from enabled repositories
    multi MAIN('list', Int :$max?, :$update, Bool :i(:$installed), *@at) {
        exit list
            |(:$max       with $max      ),
            |(:$update    with $update   ),
            |(:$installed with $installed)
            |@at
    }

    #| Upgrade installed distributions (BETA)
    multi MAIN(
        'upgrade',
        Bool :$fetch,
        Bool :$build,
        Bool :$test,
        Bool :$depends,
        Bool :$test-depends,
        Bool :$build-depends,
        Bool :$force,
        Bool :$force-resolve,
        Bool :$force-fetch,
        Bool :$force-extract,
        Bool :$force-build,
        Bool :$force-test,
        Bool :$force-install,
        Int  :$timeout,
        Int  :$fetch-timeout,
        Int  :$extract-timeout,
        Int  :$build-timeout,
        Int  :$test-timeout,
        Bool :$dry,
        Bool :$update,
        Bool :$serial,
        :$exclude,
        :to(:$install-to),
        *@identities
    ) {
        # XXX: This is a very inefficient prototype. Not sure how to handle an 'upgrade' when
        # multiple versions are already installed, so for now an 'upgrade' always means we
        # leave the previous version installed.
        exit upgrade
            |(:$fetch           with $fetch          ),
            |(:$build           with $build          ),
            |(:$test            with $test           ),
            |(:$depends         with $depends        ),
            |(:$test-depends    with $test-depends   ),
            |(:$build-depends   with $build-depends  ),
            |(:$force           with $force          ),
            |(:$force-resolve   with $force-resolve  ),
            |(:$force-fetch     with $force-fetch    ),
            |(:$force-extract   with $force-extract  ),
            |(:$force-build     with $force-build    ),
            |(:$force-test      with $force-test     ),
            |(:$force-install   with $force-install  ),
            |(:$timeout         with $timeout        ),
            |(:$fetch-timeout   with $fetch-timeout  ),
            |(:$extract-timeout with $extract-timeout),
            |(:$build-timeout   with $build-timeout  ),
            |(:$test-timeout    with $test-timeout   ),
            |(:$dry             with $dry            ),
            |(:$update          with $update         ),
            |(:$serial          with $serial         ),
            |(:$exclude         with $exclude        ),
            |(:$install-to      with $install-to     ),
            |@identities
    }

    #| View dependencies of a distribution
    multi MAIN(
        'depends',
        $identity,
        Bool :$depends,
        Bool :$test-depends,
        Bool :$build-depends,
    ) {
        # TODO: refactor this stuff which was copied from 'install'
        # So really we just need a function to handle separating the different identity types
        # and optionally delivering a message for each section.
        exit depends
            $identity,
            |(:$depends       with $depends      ),
            |(:$test-depends  with $test-depends ),
            |(:$build-depends with $build-depends),
    }

    #| View direct reverse dependencies of a distribution
    multi MAIN(
        'rdepends',
        $identity,
        Bool :$depends,
        Bool :$test-depends,
        Bool :$build-depends,
    ) {
        exit rdepends
            |(:$depends       with $depends      ),
            |(:$test-depends  with $test-depends ),
            |(:$build-depends with $build-depends),
    }

    #| Lookup locally installed distributions by short-name, name-path, or sha1 id
    multi MAIN('locate', $identity, Bool :$sha1) {
        exit locate $identity, |(:$sha1 with $sha1)
    }

    #| Detailed distribution information
    multi MAIN('info', $identity, :$update, Int :$wrap) {
        exit info $identity, |(:$update with $update), |(:$wrap with $wrap)
    }

    #| Browse a distribution's available support urls (homepage, bugtracker, source)
    multi MAIN('browse', $identity, $url-type where * ~~ any(<homepage bugtracker source>), Bool :$open) {
        exit browse $identity, $url-type, |(:$open with $open)
    }

    #| Download a single module and change into its directory
    multi MAIN('look', $identity) {
        exit look $identity
    }

    #| Smoke test
    multi MAIN(
        'smoke',
        Bool :$fetch,
        Bool :$build,
        Bool :$test,
        Bool :$depends,
        Bool :$test-depends,
        Bool :$build-depends,
        Bool :$force,
        Bool :$force-resolve,
        Bool :$force-fetch,
        Bool :$force-extract,
        Bool :$force-build,
        Bool :$force-test,
        Bool :$force-install,
        Int  :$timeout,
        Int  :$fetch-timeout,
        Int  :$extract-timeout,
        Int  :$build-timeout,
        Int  :$test-timeout,
        Bool :$update,
        Bool :$upgrade,
        Bool :$dry,
        Bool :$serial,
        :$exclude,
        :to(:$install-to),
    ) {
        exit smoke
            |(:$fetch           with $fetch          ),
            |(:$build           with $build          ),
            |(:$test            with $test           ),
            |(:$depends         with $depends        ),
            |(:$test-depends    with $test-depends   ),
            |(:$build-depends   with $build-depends  ),
            |(:$force           with $force          ),
            |(:$force-resolve   with $force-resolve  ),
            |(:$force-fetch     with $force-fetch    ),
            |(:$force-extract   with $force-extract  ),
            |(:$force-build     with $force-build    ),
            |(:$force-test      with $force-test     ),
            |(:$force-install   with $force-install  ),
            |(:$timeout         with $timeout        ),
            |(:$fetch-timeout   with $fetch-timeout  ),
            |(:$extract-timeout with $extract-timeout),
            |(:$build-timeout   with $build-timeout  ),
            |(:$test-timeout    with $test-timeout   ),
            |(:$update          with $update         ),
            |(:$upgrade         with $upgrade        ),
            |(:$dry             with $dry            ),
            |(:$serial          with $serial         ),
            |(:$exclude         with $exclude        ),
            |(:$install-to      with $install-to     ),
    }

    #| Update package indexes
    multi MAIN('update', *@names) {
        exit update |@names
    }

    #| Nuke module installations (site, home) and repositories from config (RootDir, StoreDir, TempDir)
    multi MAIN('nuke', Bool :$confirm, *@names ($, *@)) {
        exit nuke |(:$confirm with $confirm), |@names
    }

    #| Detailed version information
    multi MAIN(Bool :$version where .so) {
        exit version
    }

    multi MAIN(Bool :h(:$help)?) {
        exit help
    }
}
