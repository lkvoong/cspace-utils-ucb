drop index if exists cinefiles_denorm.persontermgroup_idx;

create index persontermgroup_idx
   on cinefiles_denorm.persontermgroup(id);

drop index if exists cinefiles_denorm.persontermgroup_termdisplayname_idx;

create index persontermgroup_termdisplayname_idx
   on cinefiles_denorm.persontermgroup(termdisplayname);

drop index if exists cinefiles_denorm.normalizeddoctitle_idx;

create index normalizeddoctitle_idx
   on cinefiles_denorm.doclist_view(cinefiles_denorm.normalizetext(doctitle));

drop index if exists cinefiles_denorm.normalizeddocsource_idx;

create index normalizeddocsource_idx
   on cinefiles_denorm.doclist_view(cinefiles_denorm.normalizetext(source));

drop index if exists cinefiles_denorm.normalizeddocauthor_idx;

create index normalizeddocauthor_idx
   on cinefiles_denorm.doclist_view(cinefiles_denorm.normalizetext(author));

drop index if exists cinefiles_denorm.normalizeddocsubject_idx;

create index normalizeddocsubject_idx
   on cinefiles_denorm.doclist_view(cinefiles_denorm.normalizetext(docsubject));

drop index if exists cinefiles_denorm.normalizeddocnamesubject_idx;

create index normalizeddocnamesubject_idx
   on cinefiles_denorm.doclist_view(cinefiles_denorm.normalizetext(docnamesubject));

drop index if exists cinefiles_denorm.normalizedfilmtitle_idx;

create index normalizedfilmtitle_idx
   on cinefiles_denorm.filmlist_view(cinefiles_denorm.normalizetext(filmtitle));

drop index if exists cinefiles_denorm.normalizedprodco_idx;

create index normalizedprodco_idx
   on cinefiles_denorm.filmlist_view(cinefiles_denorm.normalizetext(prodco));

drop index if exists cinefiles_denorm.normalizeddirector_idx;

create index normalizeddirector_idx
   on cinefiles_denorm.filmlist_view(cinefiles_denorm.normalizetext(director));

drop index if exists cinefiles_denorm.normalizedfilmsubject_idx;

create index normalizedfilmsubject_idx
   on cinefiles_denorm.filmlist_view(cinefiles_denorm.normalizetext(subject));

