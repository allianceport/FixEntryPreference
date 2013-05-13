# $Id$

package FixEntryPreference::Plugin;

use strict;
use warnings;
use Data::Dumper;


sub plugin {
    return MT->component('FixEntryPreference');
}

sub _log {
    my ($msg) = @_;
    return unless defined($msg);
    my $prefix = sprintf "%s:%s:%s: %s", caller();
    $msg = $prefix . $msg if $prefix;
    use MT::Log;
    my $log = MT::Log->new;
    $log->message($msg) ;
    $log->save or die $log->errstr;
    return;
}

sub fix_entry_preference_pref {
    my $plugin = plugin();
    my ($blog_id) = @_;
    my $plugin_params = $plugin->get_config_hash('blog:'.$blog_id) or die;

    return $plugin_params;
}


sub fix_permission {
    my ($app) = @_[0];

    my $instance = MT->instance();
    my $blog_id  = $instance->param('blog_id');
    my $plugin_params = fix_entry_preference_pref($blog_id);

    return unless $$plugin_params{fix_entry_preference_enable};

    my $type     = $instance->param('_type');
    my $author_is_admin = $app->user->is_superuser ? $app->user->is_superuser : 0;

    use MT::Permission;
    my $permission  = MT::Permission->load( { blog_id   => $blog_id,
                                                    author_id => $app->user->id },
                                                  { limit     => 1 } );

    #もしAdminではないならば、対象のBlogのアドミンのアカウントのIDを取得する。
    if ($author_is_admin){
            $permission->entry_prefs('title,text,' . $$plugin_params{fix_entry_preference_admin_config_for_entry} . '|');
            $permission->page_prefs( 'title,text,' . $$plugin_params{fix_entry_preference_admin_config_for_page}  . '|');
    } else {
            $permission->entry_prefs('title,text,' . $$plugin_params{fix_entry_preference_user_config_for_entry} . '|');
            $permission->page_prefs( 'title,text,' . $$plugin_params{fix_entry_preference_user_config_for_page}  . '|');
    };

    $permission->save or die;
    1;
};

#----- Transformer
sub hdlr_edit_entry_param {
    my ($cb, $app, $param, $tmpl) = @_;

    my $instance = MT->instance();
    my $blog_id  = $instance->param('blog_id');
    my $plugin_params = fix_entry_preference_pref($blog_id);

    return unless $$plugin_params{fix_entry_preference_enable};

    my $settings = $tmpl->getElementsByTagName('app:setting');
    for my $setting ( @$settings ) {
        my $attribute = $setting->getAttribute('class');
        if ( defined($attribute) && $attribute eq 'sort-enabled' ) {
            $setting->setAttribute('class', 'sort-disable');
        }
    }
    # Add CSS for class: .sort-disabled
    $param->{js_include} .= plugin->load_tmpl('sort_disable_css.tmpl')->text;
    1;
}

sub hdlr_edit_entry_source {
    my ($cb, $app, $tmpl_ref) = @_;

    fix_permission($app);

    my $old = quotemeta( '<$mt:setvar name="show_display_options_link" value="1"$>' );
    my $new = "";
    $$tmpl_ref =~ s!$old!$new!;
    1,
};

sub hdr_permission_post_save {
    my ($cb, $app, $obj) = @_;

    fix_permission($app);
    1;

};

1;
